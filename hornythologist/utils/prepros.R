wave2mat <- function(ID){
  
  mp3 <- readMP3(paste0('Train/',ID,'.mp3')) %>%
    normalize() %>% 
    noSilence(zero = 0,level = 0.1)
  
  mat_melfcc <- melfcc(mp3)
  
}
