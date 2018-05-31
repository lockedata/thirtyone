# needed later
fs::dir_create("balloons")
fs::dir_create("tags")

# Obviously this has to be the random seed
set.seed(31)

########### WINNERS
# winners <- purrr::map_df(1:31,
#                          twitterbookdraw::draw_winner)
# winners <- glue::glue("@{winners}$screen_name")
winners <- charlatan::ch_name(31)

library("magrittr")

create_balloon <- function(name){
  magick::image_read("assets/Balloon.png") %>%
    magick::image_annotate(name,
                           location = "+860+1900",
                           size = 70,
                           font = "roboto") %>%
    magick::image_write(glue::glue("balloons/Balloon_{name}.png"))
  
  magick::image_read("assets/Label.png") %>%
    magick::image_annotate(name,
                           location = "+860+1900",
                           size = 70,
                           font = "roboto") %>%
    magick::image_write(glue::glue("tags/Label_{name}.png"))
  
}

purrr::walk(winners, create_balloon)

########### VIZ

# initial state
data1 <- data.frame(
    x = runif(min = -20, max = 20, n = 31),
    y = runif(min = -50, max = -10, n = 31),
    stringsAsFactors = FALSE
  )
# then all balloons on a horizontal line at the top
data2 <- data1
data2$y <- 150
data2$x <- seq(-100, 100, length = 31)
# transition between the two
data <- tweenr::tween_states(list(data1, data2), 3, 1, 'linear', 31)

# then we sprinkle the tags
data3 <- data1
data3$x <- rep(seq(-40, 100, length = 5), 7)[1:31]
data3$y <- rep(seq(50, 150, length = 7), each = 5)[31:1]
data4 <- tweenr::tween_states(list(data2, data3), 3, 2, 'linear', 10)
data$image <- rep(glue::glue("balloons/Balloon_{winners}.png"), nrow(data)/31)
data4$image <- rep(glue::glue("tags/Label_{winners}.png"), nrow(data4)/31)
data4$.frame <- data4$.frame + max(data$.frame)
data <- rbind(data, data4)
data$name <- rep(winners, nrow(data)/31)

# 




library("ggplot2")
library("ggimage")

chibi <- magick::image_read("assets/chibi_happy_steph.png") %>%
  magick::image_resize("500x500")

box <- magick::image_read("assets/Box.png") %>%
  magick::image_resize("1500x1500")

plot_one_step <- function(step, data, chibi = chibi,
                          box = box){
  data <- data[data$.frame == step,]
  p <- ggplot(data) +
    geom_image(aes(x, y, image = image),
               size = 0.5) +
    ylim(c(-50, 170)) +
    xlim(c(-110, 110)) +
    theme_void() 
  
  outfil <- paste0("frames/frame_", stringr::str_pad(step, 2, pad = "0"), ".png")
  ggsave(outfil, p, width=5, height=5)
  magick::image_read(outfil) %>%
    magick::image_composite(chibi,
                            offset = "+100+900") %>%
    magick::image_composite(box,
                            offset = "+0+600")  %>%
    magick::image_crop("1500x1200+0+300")%>%
    magick::image_write(outfil)
}


purrr::walk(1:(nrow(data)/31), plot_one_step, data, chibi = chibi,
            box = box)

paste0("The winners are ", toString(winners))

# magick::image_read(fs::dir_ls("frames")) %>%
#   magick::image_join() %>%
#   magick::image_animate(fps = 10) %>%
#   magick::image_write("thirtyone.gif")