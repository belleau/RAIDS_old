% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processStudy.R
\encoding{UTF-8}
\name{appendStudy2GDS1KG}
\alias{appendStudy2GDS1KG}
\title{Create a study at GDS including the reference (first study add)}
\usage{
appendStudy2GDS1KG(
  PATHGENO = file.path("data", "sampleGeno"),
  fileNamePED,
  fileNameGDS,
  batch = 1,
  studyDF,
  listSamples = NULL,
  PATHSAMPLEGDS = NULL
)
}
\arguments{
\item{PATHGENO}{TODO a PATH to the directory genotype file of 1KG
The directory sampleGeno must contain matFreqSNV.txt.bz2}

\item{fileNamePED}{TODO}

\item{fileNameGDS}{a \code{character} string representing the file name of
the GDS study file that will be created. TODO}

\item{batch}{TODO . Default: \code{1}.}

\item{studyDF}{TODO}

\item{listSamples}{A \code{vector} of \code{string} corresponding to
the sample.ids. If \code{NULL} all samples are selected.
Default: \code{NULL}.}

\item{PATHSAMPLEGDS}{TODO a PATH to a directory where a gds specific
to the samples with coverage info is keep. Default: \code{NULL}.}
}
\value{
The function returns \code{0L} when successful.
}
\description{
TODO
}
\examples{

## Path to the demo pedigree file is located in this package
data.dir <- system.file("extdata", package="RAIDS")

## TODO
fileNamePED <- "TODO"

}
\author{
Pascal Belleau, Astrid Deschênes and Alexander Krasnitz
}
