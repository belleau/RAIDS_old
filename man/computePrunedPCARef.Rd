% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processStudy.R
\encoding{UTF-8}
\name{computePrunedPCARef}
\alias{computePrunedPCARef}
\title{Compute principal component axes (PCA) on pruned SNV with the reference
samples}
\usage{
computePrunedPCARef(gds, listRef, np = 1L)
}
\arguments{
\item{gds}{an object of class
\code{\link[SNPRelate:SNPGDSFileClass]{SNPRelate::SNPGDSFileClass}}, a SNP
GDS file.}

\item{listRef}{a \code{vector} of string representing the
identifiant of the samples in the reference (unrelated).}

\item{np}{a single positive \code{integer} representing the number of
threads. Default: \code{1L}.}
}
\value{
listPCA  a \code{list} containing two objects
pca.unrel -> \code{snpgdsPCAClass}
and a snp.load -> \code{snpgdsPCASNPLoading}
}
\description{
This function compute the PCA on pruned SNV with the reference samples
}
\details{
More information about the method used to calculate the patient eigenvectors
can be found at the Bioconductor SNPRelate website:
https://bioconductor.org/packages/SNPRelate/
}
\examples{

## Path to the demo pedigree file is located in this package
data.dir <- system.file("extdata", "RAIDS")

## TODO

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
