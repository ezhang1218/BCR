# BCR

High association rates, defined as the rate at which an antibody binds to its target, 
and the half-life of the protein-antibody complex that exceeds an apparent 
threshold are required for B cell activation. 

The association rate and half-life of the antigen-receptor both 
influence early B-cell activation, and binding site may modify 
the effect of the association rate. The proposed mathematical 
model appears to fit the data well. A larger study is needed 
to verify the findings.

# The Data

kon- the 'on' rate, or the rate at which molecules bind

koff- the 'off' rate, or the rate at which molecules disassociate

calcium_flux- a strong indicator of early B cell activation

# Work so far

The most crucial discovery we found was the contour plot: the contour plot suggests a more nuanced picture — 
while high log(kon) was associated with higher values of calcium flux, values of log(t1/2) that were too low or too high was associated with poor calcium flux. 
This suggests a model where the rate of binding is the main driver of calcium flux, and that ligands must bind to the BCR for a 
minimum period before signaling but that excessively long binding times may also interfere with signaling.

# Next steps
We started to develope a modified kinetic proofreading mathematical model and performed numerical simulations to elucidate 
potential mechanisms that could account for these complex interactions.
