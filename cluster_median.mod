# Number of points
param m; 
set M:={1..m};

# Euclidean distances matrix
param D{M,M};

# Number of clusters
param k;

# Binary matrix of the results
var x{M,M} binary;

# Cost function
minimize obj: sum{i in M, j in M} D[i,j] * x[i,j];

# Constraint 1: every point belongs to one and only one cluster 
subject to s1 {i in M}: sum{j in M} x[i,j]=1;
 
# Constraint 2: exactly k clusters exist
subject to s2 :sum{j in M} x[j,j]=k;

# Constraint 3: a point may belong to a cluster only if the cluster exists
subject to s3 {i in M, j in M}: x[j,j]>=x[i,j];