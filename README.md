Make a gif with balloons for Steph's 31th birthday
===================================================

You'll need

* to delete the content of balloons/ and tags/.

* Use [make_lotto.R](make_lotto.R)

* `rtweet` and all the token stuff. Check `rtweet` issue tracker first: currently, the API has a bug. Uncomment the rtweet code (it uses `charlatan` at the moment).

* `magick`, `tweenr`, `glue`, `ggplot2`, `ggimage`, `stringr`, `purrr`, `fs`, `magrittr`

* to get winners run `paste0("The winners are ", toString(winners))`, it's a line in the script actually.

* The `magick` gif creation at the end didn't work, maybe too many frames, potentially use an online tool, sorry. The frames are in frames/