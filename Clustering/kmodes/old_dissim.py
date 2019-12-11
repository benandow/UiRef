def dissim_meas(a, b, X, membship):
    res = []
    for idj,val_a in enumerate(a):
        sumval = 0.0
        for idr,t in enumerate(val_a):
            if b[idr] != t:
                sumval += 1.0
            else:
                # Get indices of value for membership
#                xcids = np.where(membship[idj] == 1)
                xcids = np.where(np.in1d(membship[idj].ravel(), [1]).reshape(membship[idj].shape))
                # Extract rows and calculate membership
                CJR = float((np.take(X,xcids, axis=0)[0][:,idr] == b[idr]).sum(0))     # Num objects w/ category value x_{i,r} for rth attr in jth cluster
                CJ = float(np.sum(membship[idj]))                           # Size of jth cluster
                if CJ != 0:
                    sumval += (1.0-(CJR/CJ))
        res.append(sumval)
    return res

