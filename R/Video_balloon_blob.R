library("Rvision")
library("dplyr")

my_vid <- video("./Video/balloon1.3gp")
old <- Sys.time()

for(i in 1:nframes(my_vid)){

  img <- readNext(my_vid)
  blob <- img %>%
    split() %>%
    '['(c(3,1)) %>%
    do.call(function(x, y) (x - y) > 50, .) %>%
    morph("close", iterations = 3) %>%
    simpleBlobDetector(max_area = Inf, min_area = 1000, blob_color = 255,
                       filter_by_convexity = FALSE,
                       filter_by_inertia = FALSE, min_threshold = 0)
  
  cat(i,"-", blob$id, ",", blob$x, ",", blob$x, ",", blob$size, "\n")
  new <- Sys.time()
  
  drawRectangle(img, blob$x[1] - 1 + blob$size[1]/2,
                     blob$y[1] - 1 + blob$size[1]/2,
                     blob$x[1] - 1 - blob$size[1]/2,
                     blob$y[1] - 1 - blob$size[1]/2, thickness = 2)
  drawText(img, paste0("x: ", format(blob$x[1] - 1, digits = 2, nsmall = 2),
                       "; y ", format(blob$y[1] - 1, digits = 2, nsmall = 2),
                       "; fps: ", format(1 / as.numeric(new - old),
                                         digits = 2, nsmall = 2)),
           x = 10, y = 10, font_face = 'plain', font_scale = 0.5,
           color = "black", thickness = 1)
  
  old <- new
  
  display(img, "Live test", 1, 144*4, 176*4)
}
