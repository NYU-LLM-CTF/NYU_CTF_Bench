def SmartAttack(P,Q,p):
    E = P.curve()
    Eqp = EllipticCurve(Qp(p, 2), [ ZZ(t) + randint(0,p)*p for t in E.a_invariants() ])

    P_Qps = Eqp.lift_x(ZZ(P.xy()[0]), all=True)
    for P_Qp in P_Qps:
        if GF(p)(P_Qp.xy()[1]) == P.xy()[1]:
            break

    Q_Qps = Eqp.lift_x(ZZ(Q.xy()[0]), all=True)
    for Q_Qp in Q_Qps:
        if GF(p)(Q_Qp.xy()[1]) == Q.xy()[1]:
            break

    p_times_P = p*P_Qp
    p_times_Q = p*Q_Qp

    x_P,y_P = p_times_P.xy()
    x_Q,y_Q = p_times_Q.xy()

    phi_P = -(x_P/y_P)
    phi_Q = -(x_Q/y_Q)
    k = phi_Q/phi_P
    return ZZ(k)

# Curve parameters --> Replace the next three lines with given values
p = 104659476300506756897994269952750986419030407625047738461854139794577634586771
a = 87500750625213725090142889546749918519559640917713912982938714583025938216347
b = 75425214523768437675356602387071100561157536554840166562763279490599642060809

# Define curve
E = EllipticCurve(GF(p), [a, b])
assert(E.order() == p)

# Replace the next two lines with given values
P1 = E(59300385084139009241363266789904376865818179342654846050959848920266347799109 , 18024711299477830422485962128504672946644987915402173784508977238188183740927)
P2 = E(54216563374704601783351902842637540748815963902298741762760240348532932828762 , 90585948285397011245265081663675073994813917796791386323787472233880046195822)

print(SmartAttack(P1,P2,p))
