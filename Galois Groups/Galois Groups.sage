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

def convertToPoly(coefs):
	# Define a polynomial ring for our polynomials and convert coefs to poly using this ring
	R = PolynomialRing(CC, 'x')
	return R(coefs)


# function to get the roots and Mahler measure

#Returns roots w norm greater than 1
def bigRoots(poly): 
    rootList = poly.roots()
    bigRootList = []
    for r in rootList:
        if sqrt(norm(r[0])) > 1:
            bigRootList.append(r)

    return bigRootList

def realRoots(poly): 
    rootList = list(f.roots())
    realRootList = []
    for r in rootList:
        if r[0] == conjugate(r[0]):
            realRootList.append(r)

    return realRootList

def mahlerMeasure(poly):
	rootList = list(poly.roots())
	measure = 1
	
	for s in rootList:
	    s_2 = sqrt(norm(s[0]))
	    measure = measure * max(1, s_2)

	return measure

#Returns trace polynomial 
def tracePoly(poly):
    K.<a> = NumberField(poly)
    return (a + 1/a).minpoly()

# one goal: plot the number of polynomials with Mahler Measure under a certain bound
# as you increase the degree

# things we want to collect:
# ((f) poly, roots of f outside unit circle, # of real roots, (g) trace poly, G_f, G_g, Mahler, disc)
# collect data into a csv (so we can plot it)

def KitchenSink(poly):
	# poly, degree, Mahler measure, roots outside unit circle, # real roots, trace poly, galois of poly, galois of trace, discriminant, 
    trace = tracePoly(poly)
    return [poly 
            , poly.degree(x)
            , mahlerMeasure(poly) 
            , bigRoots(poly) # roots outside unit circle
            , realRoots(poly) 
            , trace
            , getGalois(poly)
            , getGalois(trace)
            , disc(poly) # discriminant
          ] 

# decomposition groups

polys = boundedReciprocalPolyCoefs(4, 1.3)

print(polys)

k = 1
for polyCoefs in polys:
	print("Polynomial " + str(k) + ":")
	print(polyCoefs)
	print(R(polyCoefs))
	try:
			print(KitchenSink(convertToPoly(polyCoefs)))
	except:
			print("Polynomial is reducible.")
	k += 1
