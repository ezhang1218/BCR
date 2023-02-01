library(readr)
library(ggplot2)
library(tidyverse)
library(drcSeedGerm)
library(sandwich)
library(lmtest)
library(ggrepel)
library(dplyr)
library(sjPlot)
library(sjmisc)
library(ggplot2)
library(reshape)
library(plotly)
library(deSolve)
library(ggrepel)



data <- read.csv("data.csv")


#------------PRELIMINARY PLOTS------------------

plot(log(data_tri$hf), data_tri$calcium_flux)


p <- ggplot(data_tri, aes(log(hf), kon,label = calcium_flux)) +
  geom_point(aes(size = calcium_flux),color = "red")
p + geom_text_repel() + labs(title = "log(half-life) vs k_on (Size of points and labeled with CA)") 

p <- ggplot(data_tri, aes(hf, log(kon), label = Antigen, color = binding,text = paste("type:", type))) +
  geom_point(aes(size = calcium_flux), alpha = 0.5)+ 
  labs(title = "log(half-life) vs log(k_on) (Size of points ~ CA: Hover over points for more info)")

ggplotly(p)

#--------------------INTERACTION-----------------

interact_model <- lm(calcium_flux ~  log(kon)*binding, data = data_tri)
#relationship of ka and calcium flux does NOT vary by binding site
#Caution low sample size




#----------------------CONTOUR PLOT----------------------------

attach(data_tri)
tbl <- tibble(log(hf), log(kon), calcium_flux)

grid <- akima::interp(tbl$`log(hf)`, tbl$`log(kon)`, tbl$calcium_flux)
griddf <- data.frame(x = rep(grid$x, ncol(grid$z)), 
                     y = rep(grid$y, each = nrow(grid$z)), 
                     z = as.numeric(grid$z))
names(griddf) = c('log(hf)', 'log(kon)', 'calcium_flux')
p = ggplot(data = griddf,
           aes(x = `log(hf)`,
               y = `log(kon)`,
               z = calcium_flux)) + 
  geom_contour_filled(alpha = 0.8) + 
  scale_fill_viridis_d(drop = FALSE) + labs(title = "CONTOUR PLOT (CA) for log(half-life) vs log(kon)")

ggplotly(p)


#---------------------------ODE--------------------------------------


parameters <- c(R = 10^(-2),L = 10^(-6), kon = 2224000, koff = 0.06, k1 = 0.1, k2 = 0.5)
state <- c(C0 = 0,C1 = 0, C2 = 0,C3 = 0, C4 = 0,C5 = 0,C6 = 0)

Lorenz<-function(t, state, parameters) {
  with(as.list(c(state, parameters)),{
    # rate of change
    dRL <- koff*(C0+C1+C2+C3+C4+C5+C6)-kon*C0
    dC0 <- kon*L*R-koff*C0-k1*C0
    dC1 <- k1*C0-k1*C1-koff*C1
    dC2 <- k1*C1-k1*C2-koff*C2
    dC3 <- k2*C2-k2*C3-koff*C3
    dC4 <- k2*C3-k2*C4-koff*C4
    dC5 <- k2*C4-k2*C5-koff*C5
    dC6 <- k2*C5-k2*C6-koff*C6
    
    #return the rate of change
    list(c(dC0,dC1,dC2,dC3,dC4,dC5,dC6))
  }) # end with(as.list ...
}
times <- seq(0, 120, by = 0.05)

out <- ode(y = state, times = times, func = Lorenz, parms = parameters)
out = as.data.frame(out)
ggplot(data = out, aes(x = time))+
  geom_line(aes(y = C6), color = "pink", size = 1.2) + xlab("Time (s)") + ylab("RL")



