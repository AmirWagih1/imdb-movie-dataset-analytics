library(ggplot2)
library(ggpubr)
library(gridExtra)
library(dplyr)
library(magrittr)
library(purrr)


data = read.csv("movies_ratings_nulls_fixed_with_duration.csv")

#       --------------------------------- plot 1 ---------------------------------

den_males_allages_avg_vote = data.frame(x =  data %$% density(x=males_allages_avg_vote)$x , 
                                        y=data %$% density(x = males_allages_avg_vote)$y) %>%
  mutate(ci_95 = if_else(x >= unname(quantile(x , c(0.25,0.75)))[1] & x <= unname(quantile(x, c(0.25,0.75)))[2], TRUE, FALSE))

den_females_allages_avg_vote = data.frame(x =  data %$% density(x=females_allages_avg_vote)$x , 
                                          y=data %$% density(x = females_allages_avg_vote)$y) %>%
  mutate(ci_95 = if_else(x >= unname(quantile(x , c(0.25,0.75)))[1] & x <= unname(quantile(x, c(0.25,0.75)))[2], TRUE, FALSE))



plot_1_a <- ggplot(data = den_males_allages_avg_vote )+
  geom_ribbon(show.legend = FALSE,mapping = aes(x=x,ymin = 0,ymax = y,fill=ci_95)) +
  geom_line(inherit.aes = TRUE,aes(x=x,y=y,fill=NULL)) + 
  geom_vline(xintercept = unname(quantile(den_males_allages_avg_vote$x,c(0.5)))[1]) +
  annotate(geom="text",x=0, y=0.3, hjust=0 ,alpha=0.7, label=paste("Median: ",unname(quantile(den_males_allages_avg_vote$x,c(0.5)))[1]),color="black")  + 
  annotate(geom="text",x=0,y=0.28, hjust=0 ,alpha=0.7,label=paste("S.D: ", round(sqrt(var(data$males_allages_avg_vote)),2)),color="black")  + scale_fill_discrete(labels=c("5%","95%"),name="p") + 
  annotate(geom="text",x=0,y=0.26, hjust=0 ,alpha=0.7,label=paste("Skewness : ", round(skewness(data$males_allages_avg_vote),2))) +  
  annotate(geom="text",x=0,y=0.24, hjust=0 ,alpha=0.7,label=paste("95% CI : [", unname(round(quantile(data$males_allages_avg_vote,c(0.025,0.975)))[1],2),",",round(unname(quantile(data$males_allages_avg_vote,c(0.025,0.975)))[2],2),"]"))+  
  scale_fill_discrete(labels=c("5%","95%"),name="p") + 
  xlab("Avg. males rating per movie")


plot_1_b <- ggplot(data = den_females_allages_avg_vote )+
  geom_ribbon(mapping = aes(x=x,ymin = 0,ymax = y,fill=ci_95)) +
  geom_line(inherit.aes = TRUE,aes(x=x,y=y,fill=NULL)) + 
  geom_vline(xintercept = unname(quantile(den_males_allages_avg_vote$x,c(0.5)))[1]) +
  annotate(geom="text",x=0, y=0.3, hjust=0 ,alpha=0.7, label=paste("Median: ",unname(quantile(den_females_allages_avg_vote$x,c(0.5)))[1]))  + 
  annotate(geom="text",x=0,y=0.28, hjust=0 ,alpha=0.7,label=paste("S.D: ", round(sqrt(var(data$females_allages_avg_vote)),2)))  + scale_fill_discrete(labels=c("5%","95%"),name="p") + 
  annotate(geom="text",x=0,y=0.26, hjust=0 ,alpha=0.7,label=paste("Skewness : ", round(skewness(data$females_allages_avg_vote),2))) + 
  annotate(geom="text",x=0,y=0.24, hjust=0 ,alpha=0.7,label=paste("95% CI : [", unname(round(quantile(data$females_allages_avg_vote,c(0.025,0.975)))[1],2),",",round(unname(quantile(data$females_allages_avg_vote,c(0.025,0.975)))[2],2),"]"))+  
  scale_fill_discrete(labels=c("5%","95%"),name="prob.") + 
  xlab("Avg. females rating per movie")



grid.arrange(plot_1_a,plot_1_b,ncol=2) # Print plot 1

# Comment : From visualization and statistical measures Both dists 
# are almost identical and both are left skewed
# however, Females are a bit more likely to give better votes based on the median, 95% CI 


#       --------------------------------- plot 2 ---------------------------------

ggplot(data = data) + geom_density(color = "blue" , mapping = aes(x=males_allages_avg_vote)) + geom_vline(xintercept = unname(quantile(data$males_allages_avg_vote , c(0.5)))  , color = " blue") + geom_density(color = "red" , mapping = aes(x=females_allages_avg_vote)) + geom_vline(xintercept = unname(quantile(data$females_allages_avg_vote , c(0.5)))  , color = "red") + scale_x_continuous(name = "Average Raring On Movie") +
  labs(title="Males, Females Avg. rating per movie distributions",caption="Male: Blue, Female: Red \n Vertical lines indicate medians") +
  theme(
    plot.caption  = element_text(hjust = 0.5,size = 9),
    plot.title = element_text(hjust = 0.5,size = 12)
  )



# it's same plot as before but displays both distributions in the same plot and can 
# further confirm our hyphosis that both distriptutions are identical



#       --------------------------------- plot 3 ---------------------------------

# Converting long format to wide format

melted.data <- melt(data[,c("imdb_title_id","allgenders_18age_avg_vote","allgenders_30age_avg_vote","allgenders_45age_avg_vote")],id.vars = "imdb_title_id" ,variable_name = "age_cat")
names(melted.data)[3] <- "average_rating"

# Giving age categories an order
melted.data$age_cat = factor(melted.data$age_cat, levels = c("allgenders_18age_avg_vote","allgenders_30age_avg_vote","allgenders_45age_avg_vote"), ordered = TRUE)

set.seed(1)
n = melted.data[sample(nrow(melted.data),size = 1000,replace = FALSE),]
ggplot(data = n, mapping = aes(y=age_cat,x=average_rating,color=age_cat)) + geom_jitter(height = 0.1) +
  geom_boxplot()+
  scale_y_discrete(name= "Age Category", labels=c("18-30","30-45","45-")) + scale_x_continuous(name = "Average rating per movie")+ 
  scale_color_discrete(labels=c("18-30","30-45","45-")) 

# Comment: From box-plots we can notice the normality of ratings in age groups, 
# While we can also notice that the 45- age category got the most variance in their ratings


  
