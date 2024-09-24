<?php $PAGE_NAME = "HOME"; require_once "header.php"; ?>
			<!-- Banner -->
				<section id="banner">
					<div class="content">
						<header>
							<h2>The future has landed</h2>
							<p>And there are no hoverboards or flying cars.<br />
							Just apps. Lots of apps.</p>
						</header>
						<span class="image"><img src="//static.no.vulnerable.services/images/pic01.jpg" alt="APPS" /></span>
					</div>
					<a href="#one" class="goto-next scrolly">Next</a>
				</section>

			<!-- One -->
				<section id="one" class="spotlight style1 bottom">
					<span class="image fit main"><img src="//static.no.vulnerable.services/images/pic02.jpg" alt="" /></span>
					<div class="content">
						<div class="container">
							<div class="row">
								<div class="col-12">
									<header>
										<h2>But we're here to make it better</h2>
                                        <p>Introducing No Vulnerable Services Hosting, <br/>
                                        with our NoPwn&reg; guarantee.<br/>
                                        <br/>
                                        Be #unhackable.&trade;</p>
									</header>
								</div>
							</div>
						</div>
					</div>
					<a href="#two" class="goto-next scrolly">Next</a>
				</section>

			<!-- Two -->
				<section id="two" class="spotlight style2 right">
					<span class="image fit main"><img src="//static.no.vulnerable.services/images/pic03.jpg" alt="" /></span>
					<div class="content">
						<header>
							<h2>Secure your website for free*</h2>
							<p>With our complementary security audits</p>
						</header>
						<p>Each site we host receives an audit by our expert pentesters, giving you peace of mind that your sites are safe.</p>
						<ul class="actions">
							<li><a href="#contact" class="button">Learn More</a></li>
						</ul>
					</div>
					<a href="#three" class="goto-next scrolly">Next</a>
				</section>

			<!-- Three -->
				<section id="three" class="wrapper style1 special fade-up">
					<div class="container">
						<header class="major">
							<h2>Signing up is simple</h2>
						</header>
						<div class="box alt">
							<div class="row gtr-uniform">
								<section class="col-4 col-6-medium col-12-xsmall">
									<span class="icon alt major fa-comment"></span>
									<h3>Get in touch</h3>
									<p>Send us information about your company and we'll get back to you.</p>
								</section>
								<section class="col-4 col-6-medium col-12-xsmall">
									<span class="icon alt major fa-upload"></span>
									<h3>Upload</h3>
									<p>Once approved, upload your entire site to us - we'll take it from there</p>
								</section>
								<section class="col-4 col-6-medium col-12-xsmall">
									<span class="icon alt major fa-flask"></span>
									<h3>Code audit</h3>
									<p>Our experts will test and fix your code</p>
								</section>
							</div>
						</div>
						<footer class="major">
							<ul class="actions special">
								<li><a href="#contact" class="button">Sign Up Today</a></li>
							</ul>
						</footer>
					</div>
				</section>

            <!-- Contact -->
				<section id="contact" class="wrapper style2 special fade">
					<div class="container">
						<header>
							<h2>Get in touch</h2>
							<p>Give us your email address and a description of your company and we'll reach out when we have capacity.</p>
						</header>
						<form method="post" action="register.php">
							<div class="row gtr-uniform gtr-50">
								<div class="col-4 col-12-xsmall"><input type="email" name="email" id="email" placeholder="Your Email Address" required /></div>
								<div class="col-8 col-12-xsmall"><input type="text" name="description" id="description" placeholder="Tell us about your company" required /></div><br/>
								<div class="g-recaptcha" data-sitekey="6Lc-_m8UAAAAAGA6CK3_pE0syUZcymYiLKAuxCK4"></div><br/>
								<div class="col-2 col-12-xsmall"><input type="submit" value="Get Started" class="fit primary" /></div>
							</div>
						</form>
					</div>
				</section>
<?php require_once "footer.php"; ?>
