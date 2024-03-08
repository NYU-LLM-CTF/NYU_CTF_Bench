#!/usr/bin/env python3

from typing import List
from gmpy2 import gcd, next_prime, is_prime, is_divisible
import psutil
import logging
from collections import Counter
import subprocess
import argparse
import os
import time
import contextlib
from pathlib import Path
import signal
# brent is probabilistic, do it in parallel
import multiprocessing

class timeout_ctx(contextlib.ContextDecorator):
    def __init__(
        self,
        seconds,
        *,
        timeout_message="Timed out",
        suppress_timeout_errors=False,
    ):
        self.seconds = int(seconds)
        self.timeout_message = timeout_message
        self.suppress = bool(suppress_timeout_errors)
        self.logger = logging.getLogger(__name__)

    def _timeout_handler(self, signum, frame):
        self.logger.warning("[!] Timeout.")
        raise TimeoutError(self.timeout_message)

    def __enter__(self):
        signal.signal(signal.SIGALRM, self._timeout_handler)
        signal.alarm(self.seconds)

    def __exit__(self, exc_type, exc_val, exc_tb):
        signal.alarm(0)
        if self.suppress and exc_type is TimeoutError:
            return True

def primes_yield(n):
    p = i = 1
    while i <= n:
        p = next_prime(p)
        yield p
        i += 1

def primes(n):
    return list(primes_yield(n))

def rootpath():
    # os.path.dirname(os.path.realpath(__file__))
    return Path(__file__).parent.absolute()

def solverbins():
    return rootpath() / "../build_Debug/solver"

def terminate_proc_tree(pid, including_parent=False):
    parent = psutil.Process(pid)
    children = parent.children(recursive=True)
    for child in children:
        child.kill()
    if including_parent:
        parent.kill()

class CompositePrivateKey(object):
    def __init__(
        self,
        factors,
        e,
    ):
        self.factors = factors
        self.e = e
        self.n = 1
        for f in factors:
            self.n *= f
        self.d = self.derive_d_from_factors(factors, e)

    @staticmethod
    def derive_d_from_factors(factors, e):
        factor_count = Counter(factors)
        phi = 1
        for factor, exponent in factor_count.items():
            phi *= (factor - 1) * (factor ** (exponent - 1))
        d = pow(e, -1, phi)
        return d

    def __repr__(self):
        return repr(self.key)

    def __str__(self):
        return (
            "CompositePrivateKey {\n" +
            f" primes: [" + ", ".join(str(f) for f in self.factors) + "],\n" +
            f" e: {self.e},\n" +
            f" d: {self.d},\n" +
            f" n: {self.n},\n" +
            "}"
        )

def brent_parallel(n, event: multiprocessing.Event, results: multiprocessing.Queue):
    res = subprocess.check_output([solverbins() / 'brent', str(n)], text=True)
    res = res.strip()
    if res:
        res = int(res)
    results.put(res)
    event.set()

class CompositeAttack:
    def __init__(self, timeout=60, ecmdigits=25, debug=False):
        self.ecmdigits = ecmdigits
        self.processes : List[multiprocessing.Process] = []
        self.timeout = timeout
        logfmt = '%(asctime)s %(levelname)-8s %(message)s'
        if debug:
            logging.basicConfig(level=logging.DEBUG, format=logfmt)
        else:
            logging.basicConfig(level=logging.INFO, format=logfmt)
        self.logger = logging.getLogger(__name__)

    def sage_factor(self, n):
        try:
            sageresult = (
                subprocess.check_output(
                    [
                        "sage",
                        "%s/sage/factor.sage" % rootpath(),
                        str(n),
                    ],
                    timeout=self.timeout,
                    stderr=subprocess.DEVNULL,
                )
                .decode("utf8")
                .rstrip()
            )
            sageresult = sageresult.split(" ")
            return [int(p) for p in sageresult]
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
            return None

    def ecm_attack(self, n):
        path_to_sage_interface = "%s/sage/ecm.sage" % rootpath()
        sage_find_factor_n = str(n)

        try:
            if self.ecmdigits is not None:
                sage_find_factor_cmd = [
                    "sage",
                    path_to_sage_interface,
                    sage_find_factor_n,
                    str(self.ecmdigits),
                ]
            else:
                sage_find_factor_cmd = [
                    "sage",
                    path_to_sage_interface,
                    sage_find_factor_n,
                ]

            sage_proc = subprocess.Popen(
                sage_find_factor_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
            try:
                sage_proc.wait(timeout=self.timeout)
                stdout, stderr = sage_proc.communicate()
                sageresult = int(stdout)
            except (
                subprocess.CalledProcessError,
                subprocess.TimeoutExpired,
                TimeoutError,
            ):
                terminate_proc_tree(os.getpgid(sage_proc.pid))
                # Make really sure they're dead
                subprocess.call(['killall', 'ecm'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

                return None
            return sageresult
        except KeyboardInterrupt:
            return None

    def brent_mp(self, n, timeout):
        # Use all available cores
        num_processes = multiprocessing.cpu_count()
        # Shared event among all processes
        event = multiprocessing.Event()
        # Shared queue to hold results
        results = multiprocessing.Queue()

        # Start processes
        for _ in range(num_processes):
            p = multiprocessing.Process(target=brent_parallel, args=(n, event, results))
            p.start()
            self.processes.append(p)

        # Wait for one of them to signal
        self.logger.info(f"[.] Waiting for brent results, timeout={timeout}s")
        res = event.wait(timeout=timeout)
        if not res:
            self.logger.info(f"[!] event.wait() returns False after {timeout}s!")

        # See if any processes returned
        finished_count = 0
        for p in self.processes:
            if not p.is_alive():
                finished_count += 1
                p.join()
        self.logger.info(f"[.] {finished_count}/{num_processes} processes finished")

        # Get any results from the queue
        brent_results = []
        for _ in range(max(finished_count,5)):
            try:
                brent_results.append(results.get(timeout=1))
            except multiprocessing.TimeoutError:
                pass
            except multiprocessing.queues.Empty:
                break
        if not brent_results:
            self.logger.warning(f"[!] No brent results; {finished_count} processes returned")
        else:
            self.logger.info(f"[.] Got brent results: {brent_results}")
            brent_results = list(set(brent_results))
            self.logger.info(f"[.] Got brent results (dedup): {brent_results}")

        # Terminate processes
        while self.processes:
            p = self.processes.pop()
            if p.is_alive():
                p.kill()

        # Make really sure they're dead
        subprocess.call(['killall', 'brent'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        return brent_results

    def derive_d_from_factors(self, factors, e):
        key = CompositePrivateKey(factors, e)
        return key.d

    def attack(self, n, e):
        """Bitflip key factorization attack"""
        with timeout_ctx(self.timeout):
            try:
                factors = self.factor_composite(n)
                self.logger.info(f"[*] Found factors: {factors}")

                if factors is not None:
                    d = self.derive_d_from_factors(factors, e)
                    result = self.test_decryption(n, e, d)
                    if result:
                        self.logger.info(f"[*] SUCCESS: Found private key: {d}")
                    else:
                        self.logger.info(f"[-] FAILED: test decryption failed with: {d}")
                    priv_key = CompositePrivateKey(
                        factors,
                        e,
                    )
                    return priv_key
                else:
                    self.logger.info(f"[-] Failed to factorize {n}")
                    return None
            except TimeoutError:
                self.logger.info(f"[-] Timeout reached")

    def stage1(self, current_n):
        """Try small factors. Returns (done?, factors, current_n)"""
        # If n' is composite, the best approach is to find small factors
        # (say up to 16 bits) using a greatest common divisor operation
        # with the product of the first primes.
        self.logger.info(f"[*] Stage 1: Trying small factors")
        small_factors = []
        small_primes = primes(2**16)
        small_prime_product = 1
        for p in small_primes:
            small_prime_product *= p
        if gcd(current_n, small_prime_product) != 1:
            for p in small_primes:
                while is_divisible(current_n, p):
                    small_factors.append(p)
                    self.logger.info(f"[*] Found small factor: {p}")
                    current_n //= p
            if small_factors:
                self.logger.info(f"[*] Found small factors: {small_factors}")
            self.logger.info(f"[*] After Stage 1, remaining: {current_n} ({current_n.bit_length()} bits)")

        else:
            self.logger.info("gcd(n, product of small primes) == 1, skipping small factors")

        if is_prime(current_n) or current_n == 1:
            if current_n != 1: small_factors.append(current_n)
            done = True
        else:
            done = False
        return done, small_factors, current_n

    def stage2(self, current_n):
        # The next step is to use Pollard’s ρ algorithm (or Brent’s variant):
        # this algorithm can easily find factors up to 40...60 bits.
        self.logger.info(f"[*] Stage 2: Pollard's rho (Brent variant), using multiple processes")
        brent_factors = []
        brent_res = []
        # Don't spend more than 30% of our timeout on this step
        BRENT_TIME_BUDGET = self.timeout * 0.3
        brent_time_remaining = BRENT_TIME_BUDGET
        while not is_prime(current_n) and current_n != 1 and (not brent_res or max(brent_res) < 2**60):
            self.logger.info(f"[*] Running one round of MP brent with n={current_n}, timeout={brent_time_remaining}")
            brent_start_time = time.time()
            brent_res = self.brent_mp(current_n, brent_time_remaining)
            brent_time_remaining -= time.time() - brent_start_time
            self.logger.info(f"[.] Found brent factors: {brent_res}")

            # Split and deduplicate brent factors
            brent_factor_set = set()
            for brent_factor in brent_res:
                # Brent returns composites, so factor those here
                if not is_prime(brent_factor):
                    brent_res_i_l = self.sage_factor(brent_factor)
                    self.logger.info(f"[.] Split {brent_factor} into: {brent_res_i_l}")
                    brent_factor_set.update(brent_res_i_l)
                else:
                    brent_factor_set.add(brent_factor)

            for b in brent_factor_set:
                assert is_divisible(current_n, b)
                while is_divisible(current_n, b):
                    brent_factors.append(b)
                    current_n //= b
                    self.logger.info(f"[*] Added brent factor: {b}")
            if brent_time_remaining <= 0:
                self.logger.warning(f"[!] Giving up on brent after {BRENT_TIME_BUDGET+abs(brent_time_remaining)}s")
                break
        if brent_factors:
            self.logger.info(f"[+] Found brent factors: {brent_factors}")
        self.logger.info(f"[*] After Stage 2, remaining: {current_n} ({current_n.bit_length()} bits)")

        if is_prime(current_n) or current_n == 1:
            if current_n != 1: brent_factors.append(current_n)
            done = True
        else:
            done = False
        return done, brent_factors, current_n

    def stage3(self, current_n):
        # A third step consists of Lenstra’s Elliptic Curve factorization Method
        # (ECM) [38]: ECM can quickly find factors up to 60...128 bits (the record
        # is a factor of about 270 bits2). Its complexity to find the smallest prime
        # factor p'_s is equal to O(L_{p'_s}[1/2, √2]). While ECM is asymptotically
        # less efficient than GNFS (because of the parameter 1/2 rather than 1/3),
        # the complexity of ECM depends on the size of the smallest prime factor
        # p'_s rather than on the size of the integer n' to factorize. Once a prime
        # factor p'_i is found, n' is divided by it, the result is tested for
        # primality and if the result is composite, ECM is restarted with
        # argument n'/p'_i.
        self.logger.info(f"[*] Stage 3: ECM using Sage")
        ecm_factors = []
        while not is_prime(current_n):
            ecm_res = self.ecm_attack(current_n)
            if not ecm_res:
                break
            self.logger.info(f"[.] Found ecm factor: {ecm_res}")
            # Split and deduplicate ecm factors
            ecm_factor_set = set()
            if is_prime(ecm_res):
                ecm_factor_set.add(ecm_res)
            else:
                ecm_res_factors = self.sage_factor(ecm_res)
                self.logger.info(f"[.] Split {ecm_res} into: {ecm_res_factors}")
                ecm_factor_set.update(ecm_res_factors)

            for ec in ecm_factor_set:
                assert is_divisible(current_n, ec)
                while is_divisible(current_n, ec):
                    ecm_factors.append(ec)
                    self.logger.info(f"[*] Added ecm factor: {ec}")
                    current_n //= ec
        if ecm_factors:
            self.logger.info(f"[+] Found ecm factors: {ecm_factors}")
        self.logger.info(f"[*] After Stage 3, remaining: {current_n} ({current_n.bit_length()} bits)")

        if is_prime(current_n) or current_n == 1:
            if current_n != 1: ecm_factors.append(current_n)
            done = True
        else:
            done = False
        return done, ecm_factors, current_n

    def factor_composite(self, n):
        current_n = n
        factors = []
        for stage in self.stage1, self.stage2, self.stage3:
            done, stage_factors, current_n = stage(current_n)
            factors += stage_factors
            if done:
                self.logger.info("[*] Done, factors are: " + str(factors))
                return factors

        # If we get here, we failed to factorize n
        self.logger.info(f"[-] Failed to factorize {n}")
        self.logger.info(f"[-] Found factors: {factors}")
        self.logger.info(f"[-] Remaining: {current_n} ({current_n.bit_length()} bits)")

        return None

    def test_decryption(self, n, e, d):
        e = 65537
        # Test decryption
        m = 123456789
        c = pow(m, e, n) # Encrypt: c = m^e mod n
        m2 = pow(c, d, n) # Decrypt: m2 = c^d mod n
        if m != m2:
            return False
        print(f"Decryption of message with derived d={d} works")
        return True

    def test(self):
        factors = []
        test_n = 1
        p = 2**16
        for i in range(10):
            for j in range(3): p = next_prime(p*2)
            print(p)
            factors.append(p)
            test_n *= p

        # Include one duplicate
        factors.append(p)
        test_n *= p

        computed_factors = self.factor_composite(test_n)
        for f in computed_factors:
            print(f"Found factor {f} (" + ("prime" if is_prime(f) else "composite") + ")")

        computed_factors.sort()
        factors.sort()
        if computed_factors != factors:
            return False
        print("Factors match")

        e = 65537
        d = self.derive_d_from_factors(computed_factors, e)
        dec_result = self.test_decryption(test_n, e, d)
        if not dec_result:
            return False
        print(f"Decryption of message with derived d={d} works")

        return True

    # Destructor
    def __del__(self):
        while self.processes:
            p = self.processes.pop()
            if p.is_alive():
                p.kill()

def main():
    parser = argparse.ArgumentParser(description='RSA composite key attack')
    parser.add_argument('e', type=int, help='Public exponent')
    parser.add_argument('n', type=int, help='Public modulus')
    parser.add_argument('-t', '--timeout', type=int, default=60, help='Timeout for factorization attempts')
    parser.add_argument('-d', '--debug', action='store_true', help='Enable debug logging')
    args = parser.parse_args()

    attack = CompositeAttack(timeout=args.timeout, debug=args.debug)
    key = attack.attack(args.n, args.e)
    if key:
        print(f"[*] Found key: {key}")

if __name__ == '__main__':
    main()
