% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processStudy.R
\encoding{UTF-8}
\name{computePCAForSamples}
\alias{computePCAForSamples}
\title{Project patients onto existing principal component axes (PCA)}
\usage{
computePCAForSamples(gds, PATHSAMPLEGDS, listSamples, np = 1L)
}
\arguments{
\item{gds}{an object of class
\code{\link[SNPRelate:SNPGDSFileClass]{SNPRelate::SNPGDSFileClass}}, a SNP
GDS file.}

\item{PATHSAMPLEGDS}{the path of an object of class \code{gds} related to
the sample}

\item{listSamples}{a \code{vector} of string representing the samples for
which compute the PCA.}

\item{np}{a single positive \code{integer} representing the number of
threads. Default: \code{1L}.}
}
\value{
The integer \code{0} when successful.
}
\description{
This function calculates the patient eigenvectors using
the specified SNP loadings.
}
\details{
More information about the method used to calculate the patient eigenvectors
can be found at the Bioconductor SNPRelate website:
https://bioconductor.org/packages/SNPRelate/
}
\examples{

## TODO
gds <- "TODO"

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
