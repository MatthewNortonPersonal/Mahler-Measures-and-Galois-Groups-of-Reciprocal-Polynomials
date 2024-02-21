R.<x> = PolynomialRing(QQ); K.<a> = NumberField(x^10+x^9-x^7-x^6-x^5-x^4-x^3+x+1); G = K.galois_group()

(a+1/a).minpoly()s