% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/synthetic.R
\encoding{UTF-8}
\name{syntheticGeno}
\alias{syntheticGeno}
\title{TODO}
\usage{
syntheticGeno(
  gds,
  gdsRefAnnot,
  gdsSampleFile,
  data.id.profile,
  listSampleRef,
  nbSim = 1,
  prefId = "",
  pRecomb = 0.01,
  minProb = 0.999,
  seqError = 0.001
)
}
\arguments{
\item{gds}{an object of class \code{gds} opened}

\item{gdsRefAnnot}{an object of class \code{gds} opened}

\item{gdsSampleFile}{a \code{character} string representing the file name of
the GDS file containing the information about the samples.}

\item{data.id.profile}{a \code{character} string TODO}

\item{listSampleRef}{a \code{character} string TODO}

\item{nbSim}{a single positive \code{integer} TODO}

\item{prefId}{a \code{string} TODO}

\item{pRecomb}{a \code{numeric} between 0 and 1 TODO. Default: \code{0.01}.}

\item{minProb}{a single \code{numeric}  TODO. Default: \code{0.999}.}

\item{seqError}{a single \code{numeric}  TODO. Default: \code{0.001}.}
}
\value{
\code{OL} when the function is successful.
}
\description{
TODO
}
\examples{

# TODO

}
\author{
Pascal Belleau, Astrid Deschênes and Alex Krasnitz
}
