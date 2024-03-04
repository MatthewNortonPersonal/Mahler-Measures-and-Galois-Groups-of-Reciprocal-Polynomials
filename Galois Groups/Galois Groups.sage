def boundedReciprocalPolyCoefs(d, M):
    possiblePoly = []
    assert d % 2 == 0
    n = d / 2
    # create a ring to make polynomials (for testing whether the polynomial is reducible)
    R.<x> = PolynomialRing(QQ)
    # calculate the bounds for each coefficient
    bounds = [M * binomial(d, i) for i in range(0, n+1)]
    # this line is for testing v
    print("bounds: ")
    print(bounds)
    
    # this is done to account for the fact that the xmrange function always starts at 0
    tempBounds = [2 * bound + 1 for bound in bounds]
    possibleCoef = list(xmrange(tempBounds))
    
    # shift the values back to fix the coefficients, and add the remaining coefficients
    # (for the terms of degree n + 1 or higher)
    # these are known since the polynomial is reciprocal
    for coefs in possibleCoef:
        fixedCoefs = [int(coefs[i] - bounds[i]) for i in range(len(bounds))]
        remainingCoefs = [fixedCoefs[n - (i + 1)] for i in range(n)]
        fixedCoefs.extend(remainingCoefs)
        possiblePoly.append(fixedCoefs)
    
    # filter out all the polynomials with 0 as the first coefficient (since this would mean the
    # degree of the polynomial would be less than d)
    for polyCoefs in possiblePoly:
        if polyCoefs[0] == 0:
            possiblePoly.remove(polyCoefs) # this might be slow, maybe it would be better to use indices

    return possiblePoly

# computes the galois group for the given polynomial.
def getGalois(poly):
    # make sure the polynomial is not reducible before
    # computing its Galois group
    # assert poly.is_irreducible
    K.<a> = NumberField(poly)
    G = K.galois_group()
    return G

polys = boundedReciprocalPolyCoefs(4, 1.3)


print(polys)

# Define a polynomial ring for our polynomials
R = PolynomialRing(QQ, 'x')

# I'm getting an issue computing the Galois group for a reducible polynomial.
k = 1
for polyCoefs in polys:
    print("Polynomial " + str(k) + ":")
    print(polyCoefs)
    print(R(polyCoefs))
    try:
        print(getGalois(R(polyCoefs)))
    except:
        print("Polynomial is reducible.")
    k += 1

# one goal: plot the number of polynomials with Mahler Measure under a certain bound
# as you increase the degree

# things we want to collect:
# ((f) poly, roots of f outside unit circle, # of real roots, (g) trace poly, G_f, G_g, Mahler, disc)
# collect data into a csv (so we can plot it)


# decomposition groups