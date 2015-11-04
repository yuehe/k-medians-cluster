# Kruskal's algorithm for the Minimum Spanning Tree (MST) problem


########### Input Data ###########
set V ordered;	  	    # Vertices
set E within {V,V};	    # Edges
param c {E};

data kruskal.dat;

param n := card(V);


set T within E default {};	# The set of edges in the MST
set F within {V,V};		# The set of edge which have not been inspected
set Best_Edges within E;	# The set of minimum-cost edges in F

param component	 {V} default 0;	# If component[i] = 0, then the edges in T
				# do not yet span i. Otherwise, component[i]
				# indicates which connected component of T
				# contains i.

param iter default 1;

let F := E;
repeat while card(T) < n - 1 {
  let Best_Edges := {(i,j) in F: c[i,j] == min{(u,v) in F} c[u,v]};
  let F := F diff Best_Edges;
  
  for {(i,j) in Best_Edges} {
    printf "=-=-=-=-=-=-=-=-= Start Iteration %d =-=-=-=-=-=-=-=-=-=-=-=-=\n",iter;
    display T;
    display F;
    display component;

    printf "Testing edge (%d,%d)\n",i,j; 
    if component[i] == 0 then {
      if component[j] == 0 then {
         # Case 1: neither vertex is in the tree. 
         # Start a new component with (i,j).
	 let component[i] := max{v in V} component[v] + 1;
	 let component[j] := component[i];
	 let T := T union {(i,j)};
      } else {
         # Case 2: j is in the tree, but i isn't.
         # Add (i,j) to the component containing j
	 let component[i] := component[j];
	 let T := T union {(i,j)};
      }
    } else {
      if component[j] == 0 then {
         # Case 3: i is in the tree, but j isn't.
         # Add (i,j) to the component containing i
	 let component[j] := component[i];
	 let T := T union {(i,j)};
      } else if component[i] <> component[j] then {
	# Case 4: i and j are in different connected components; merge the components;
        for {v in V: component[v] == component[j]} let component[v] := component[i];
	let T := T union {(i,j)};
      } else printf "Adding edge (%d,%d) would create a cycle.\n\n",i,j;
    } # test for cycles

    display T;
    display F;
    display component;
    printf "=-=-=-=-=-=-=-=-=-= End Iteration %d =-=-=-=-=-=-=-=-=-=-=-=-=\n\n",iter;
    

    if card(T) == n - 1 then
      break;
    else
     let iter := iter + 1;
  } # for (i,j) in Best_Edges
}

printf "A MST for this graph has cost %d.\n",sum{(i,j) in T} c[i,j];
display T;