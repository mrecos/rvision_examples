library("Rvision")
library("dplyr")
library("magick")

######## Not complete:
# need to extract blob and predict on that, not the entire image

# instantiate the model
model <- application_resnet50(weights = 'imagenet')

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
    # for(i in 1:nrow(blob)){
    #   drawRectangle(img, blob$x[i] - 1 + blob$size[i]/2,
    #                 blob$y[i] - 1 + blob$size[i]/2,
    #                 blob$x[i] - 1 - blob$size[i]/2,
    #                 blob$y[i] - 1 - blob$size[i]/2, thickness = 2)
    # }
    
    bbb = 10
    x1 = blob$x[1] + bbb + blob$size[1]/2
    y1 = blob$y[1] + bbb + blob$size[1]/2
    x2 = blob$x[1] - bbb - blob$size[1]/2
    y2 = blob$y[1] - bbb - blob$size[1]/2
    drawRectangle(img, x1,y1,x2,y2, thickness = 2)
    
    # f <- function(m) t(m)[,nrow(m):1]
    blob1_img <- as.matrix(img)
    # blob1_t <- f(blob1_img[,,1:3])
    # image.default(blob1_t[x2:x1,y2:y1])
    # blob1_bb <- blob1_img[x2:x1,y2:y1,]
    
    img32 <- resize(img, 224,224)
    img32_array <- image_to_array(as.matrix(img32))
    img32_array <- array_reshape(img32_array, c(1, dim(img32_array)))
    img32_proc <- imagenet_preprocess_input(img32_array)
    preds <- model %>% predict(img32_proc)
    bb1 <- imagenet_decode_predictions(preds, top = 1)[[1]][,2:3]
    print(bb1)

    drawText(img, paste0(format(as.character(bb1[1])),
             "-", format(round(as.numeric(bb1[2]),2), digits = 2, nsmall = 0),
             "%"),
             x = 10, y = 10, font_face = 'plain', font_scale = 3.5,
             color = "red", thickness = 3)
  }
  old <- new
  
  display(img, "Live test", 1, 360*2, 640*2)
}

destroyDisplay("Live test")
release(my_stream)
