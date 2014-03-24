\docType{package}
\name{gnuparallel-package}
\alias{gnuparallel}
\alias{gnuparallel-package}
\title{GNU Parallel}
\description{
  Loading of GNU Parallel -{}-results output
}
\details{
  \tabular{ll}{ Package: \tab gnuparallel\cr Type: \tab
  Package\cr Version: \tab 2014.01.22\cr Date: \tab 2014-01-22\cr
  License: \tab GPL (>= 3)\cr LazyLoad: \tab yes\cr }

  Implements a number of functions for reading GNU Parallel results dir.
}
\examples{
library(gnuparallel)
if(system(paste("parallel --header : --results foobar",
   "printf out{let}\\\\\\\\\\\\\\\\tout{num}\\\\\\\\\\\\\\\\nline2{let}\\\\\\\\\\\\\\\\t{num}\\\\\\\\\\\\\\\\n",
   "::: let a b c ::: num 4 5 6"))) {
  stop("GNU Parallel must be installed. 10 seconds installation: wget -O - pi.dk/3/| bash");
}
fn <- gnu.parallel.filenames("foobar")
gnu.parallel.load(fn)
gnu.parallel.load.lines(fn)
gnu.parallel.load.data.frame(fn)
gnu.parallel.load.data.table(fn)
}
\author{
  Ole Tange \email{tange@gnu.org}, David Rosenberg
}
\references{
  Tange, O. (2011) GNU Parallel - The Command-Line Power Tool,
  ;login: The USENIX Magazine, February 2011:42-47.
}
\seealso{
  \code{\link{gnu.parallel.filenames}}, \code{\link{gnu.parallel.load}},
  \code{\link{gnu.parallel.load.data.frame}}, \code{\link{gnu.parallel.load.data.table}},
  \code{\link{gnu.parallel.load.lines}}
}
\keyword{parallel}

