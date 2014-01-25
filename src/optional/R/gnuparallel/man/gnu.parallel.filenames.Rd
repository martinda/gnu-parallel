\name{gnu.parallel.filenames}
\alias{gnu.parallel.filenames}
\title{Find the filenames in a GNU Parallel results dir}
\usage{
  gnu.parallel.filenames(resdir)
}
\arguments{
  \item{resdir}{results dir from GNU Parallel's --results}
}
\value{
  filenametable with a column for each of GNU Parallel's input sources
  and a column for file name of both stdout and stderr
}
\description{
  Find the filenames in a GNU Parallel results dir
}
\author{
  Ole Tange \email{tange@gnu.org}, David Rosenberg
}
\references{
  Tange, O. (2011) \emph{GNU Parallel - The Command-Line Power Tool} ;login:
  The USENIX Magazine, February 2011:42-47.
}
