library("Rvision")
library("dplyr")


my_stream <- stream(0)
newDisplay("Live test", 400, 400)
old <- Sys.time()

while(TRUE){
  img <- readNext(my_stream)
  blob <- img %>%
    split() %>%
    '['(c(3,1)) %>%
    do.call(function(x, y) (x - y) > 50, .) %>%
    morph("close", iterations = 3) %>%
    # medianBlur(21) %>%
    simpleBlobDetector(max_area = Inf, min_area = 1000, blob_color = 255,
                       filter_by_convexity = FALSE,
                       filter_by_inertia = FALSE, min_threshold = 0)
  
  # cat(i,"-", blob$id, ",", blob$x, ",", blob$x, ",", blob$size, "\n")
  new <- Sys.time()
  
  if(nrow(blob) > 0){
    bbb = 10
    x1 = blob$x[1] + bbb + blob$size[1]/2
    y1 = blob$y[1] + bbb + blob$size[1]/2
    x2 = blob$x[1] - bbb - blob$size[1]/2
    y2 = blob$y[1] - bbb - blob$size[1]/2
    drawRectangle(img, x1,y1,x2,y2, thickness = 2)
    
    img32 <- resize(img, 28,28)
    img32_gray <- changeColorSpace(img32,"GRAY")
    img32_array <- image_to_array(as.matrix(img32_gray))
    img32_array <- array_reshape(img32_array, c(1, dim(img32_array)))
    preds <- MNIST_model %>% 
      predict(img32_array) %>%
      data.frame() %>%
      magrittr::set_colnames(seq(0,9,1))
    preds$top <- as.numeric(colnames(preds)[max.col(preds,ties.method="first")])
    print(preds[1,])
    
    drawText(img, paste0("pred: ", format(preds$top[1], digits = 2, nsmall = 0)),
             x = 30, y = 30, font_face = 'plain', font_scale = 4,
             color = "red", thickness = 3)
  }
  old <- new
  
  display(img, "Live test", 1, 360*2, 640*2)
}

destroyDisplay("Live test")
release(my_stream)
