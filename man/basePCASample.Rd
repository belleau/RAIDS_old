% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/process1KG.R
\encoding{UTF-8}
\name{basePCASample}
\alias{basePCASample}
\title{TODO}
\usage{
basePCASample(gds, listSample.Ref = NULL, listSNP = NULL, np = 1)
}
\arguments{
\item{gds}{an object of class
\code{\link[SNPRelate:SNPGDSFileClass]{SNPRelate::SNPGDSFileClass}}, a SNP
GDS file.}

\item{listSample.Ref}{A \code{vector} of \code{string} corresponding to
the sample.ids}

\item{listSNP}{the list of snp.id keep}

\item{np}{a single positive \code{integer} representing the number of
threads. Default: \code{1}.}
}
\value{
TODO a \code{list}  with with two objects
pca.unrel -> \code{snpgdsPCAClass}
and a snp.load -> \code{snpgdsPCASNPLoading}
}
\description{
TODO
}
\examples{

## Path to the demo pedigree file is located in this package
data.dir <- system.file("extdata", package="RAIDS")

## TODO

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
