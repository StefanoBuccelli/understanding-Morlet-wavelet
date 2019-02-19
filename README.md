# Understanding the Morlet wavelet
Lot of resources can be found online (but different formulas, different names for the same parameter etc..). 

Here some slides (work in progress): https://docs.google.com/presentation/d/17iaibu6Z-4mruF550cYVrNbj6w2ZjindhKWd7NA0_nE/edit?usp=sharing

## Code
* invcwt_v1.4:
  * Wavelet software was provided by C. Torrence and G. Compo, and is available at URL:    http://paos.colorado.edu/research/wavelets/''. Reference: Torrence, C. and G. P. Compo, 1998: A Practical Guide to Wavelet   Analysis. <I>Bull. Amer. Meteor. Soc.</I>, 79, 61-78. paper: http://paos.colorado.edu/research/wavelets/bams_79_01_0061.pdf
  * this code was found here: https://it.mathworks.com/matlabcentral/fileexchange/20821-continuous-wavelet-transform-and-inverse
  * related and detailed wavelet tutorial on the same paper: https://github.com/chris-torrence/wavelets


* paper 2015: 
  * Postnikov, Eugene B., Elena A. Lebedeva, and Anastasia I. Lavrova. "Computational implementation of the inverse continuous wavelet transform without a requirement of the admissibility condition." Applied Mathematics and Computation 282 (2016): 128-136
  * can be found here: https://arxiv.org/pdf/1507.04971.pdf


* wavelet_matlab just to test how the cwt works (Wavelet Toolbox needed)
* comparing_morlet_formulas is a comparison between cmorwavf and the one present in:
  * Tallon-Baudry, Catherine, et al. "Stimulus specificity of phase-locked and non-phase-locked 40 Hz visual responses in human." Journal of Neuroscience 16.13 (1996): 4240-4249. Link: 
    * http://www.jneurosci.org/content/jneuro/16/13/4240.full.pdf
  * Hipp, Joerg F., et al. "Large-scale cortical correlation structure of spontaneous oscillatory activity." Nature neuroscience 15.6 (2012): 884. Link:
    * https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3861400/
  * Both refers to this original aricle for the wavelet definition: Analysis of sound patterns through wavelet transforms https://www.researchgate.net/profile/Richard_Kronland-Martinet/publication/263794237_Analysis_of_sound_patterns_through_wavelet_transforms/links/53ece4d40cf26b9b7dbff7a6/Analysis-of-sound-patterns-through-wavelet-transforms.pdf

## Other resources:
  *  Lilly, J. M. jLab: A data analysis package for Matlab, version 1.6.2. 2016. http://www.jmlilly.net/jmlsoft.html. 
  * The Uncertainty Principle & Time-Bandwidth Product: https://www.ee.iitb.ac.in/uma/~pawar/Wavelet%20Applications/Chapters_review/ch03_Gr3_Gr2.pdf
  * Higher-Order Properties of Analytic Wavelets: referred by cwt Matlab help (explains the different normalization (L1) instead of (L2). May be why we have such a discrepancy between Tannon and Matlab?
  https://arxiv.org/pdf/0802.2377.pdf
  * Mike X Cohen:
    * refer to: http://mikexcohen.com/lectures.html for a detailed and clear description of wavelets (matlab code is also available there and here:
      * https://github.com/vncntprvst/tools/tree/master/AnalyzingNeuralTimeSeriesData
    * New paper: https://www.biorxiv.org/content/biorxiv/early/2018/08/21/397182.full.pdf
  * National:
    * http://zone.ni.com/reference/en-XX/help/372656C-01/lvasptconcepts/wa_awt/
  * Mathworks:
    * https://it.mathworks.com/help/wavelet/gs/choose-a-wavelet.html
    * https://it.mathworks.com/help/pdf_doc/wavelet/wavelet_ug.pdf
    * https://it.mathworks.com/help/pdf_doc/wavelet/wavelet_ref.pdf
    * https://it.mathworks.com/help/pdf_doc/wavelet/wavelet_gs.pdf
  * Web pages:
    * https://www.dsprelated.com/freebooks/sasp/Wavelet_Filter_Banks.html
    * https://dsp.stackexchange.com/questions/41349/complex-morlet-coefficient?answertab=votes#tab-top
    * https://ccrma.stanford.edu/~jos/sasp/Continuous_Wavelet_Transform.html : "The center frequency is typically chosen so that second peak is half of first approx = 5.336. In this case psi(0) almost zero: which is close enough to zero-mean for most practical purposes"
  * Books: 
    * Computational Signal Processing with Wavelets (the one on which Matlab complex Morlet formula is based) https://books.google.it/books?id=SMngBwAAQBAJ&lpg=PA66&vq=morlet&hl=it&pg=PA66#v=onepage&q&f=false
    * The Illustrated Wavelet Transform Handbook: Introductory Theory and Applications in Science: https://books.google.it/books?id=VrTZDQAAQBAJ&lpg=PP1&dq=The%20Illustrated%20Wavelet%20Transform%20Handbook%3A%20Introductory%20Theory%20and%20Applications%20in%20Science&hl=it&pg=PP1#v=onepage&q=5.83&f=false. Page 35
  * A Tutorial of the Morlet Wavelet Transform  http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=924D894AEBCA3A939CC1297FF28B1BA4?doi=10.1.1.695.137&rep=rep1&type=pdf
  * Wavelet Transforms in Time Series Analysis: https://www.atmos.umd.edu/~ekalnay/syllabi/AOSC630/Wavelets_2010.pdf Nice and simple explanation of wavelet in general and Morlet in particular. 
  * Morlet Wavelets in Quantum Mechanics: https://arxiv.org/ftp/arxiv/papers/1001/1001.0250.pdf Complicated but detailed description and calculation of admissibility constant.

