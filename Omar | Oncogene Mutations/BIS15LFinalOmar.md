---
title: "Bis15L Final Project"
author: "Omar Afzal"
date: "2021-03-11"
output:
  html_document: 
    keep_md: yes
    theme: spacelab
---




## Load the libraries

```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.3     v purrr   0.3.4
## v tibble  3.0.6     v dplyr   1.0.4
## v tidyr   1.1.2     v stringr 1.4.0
## v readr   1.4.0     v forcats 0.5.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(janitor)
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

```r
library(here)
```

```
## here() starts at C:/Users/Omar/Desktop/BIS15L-W21-DataScienceBiologists-main/lab1
```

```r
library(ggthemes)
if (!require("qqman")) install.packages('qqman')
```

```
## Loading required package: qqman
```

```
## 
```

```
## For example usage please run: vignette('qqman')
```

```
## 
```

```
## Citation appreciated but not required:
```

```
## Turner, S.D. qqman: an R package for visualizing GWAS results using Q-Q and manhattan plots. biorXiv DOI: 10.1101/005165 (2014).
```

```
## 
```

```r
library(qqman)
library(dplyr)
if (!require("ggrepel")) install.packages('ggrepel')
```

```
## Loading required package: ggrepel
```

```r
library(ggrepel)
```



```r
#What are SNPs and why do they matter? Cancer is a conglomerate of gain-of-function of oncogenes and the loss-of-function of tumor suppressor genes. Identification of single-nucleotide polymorphisms and other mutations at important gene sites can be correlated with being cancer drivers in addition to their disease rates and severity. 
```


```r
#How do we interpret odds ratios and GWAS statistics?

#What are the odds of developing breast cancer if my Chromosome 5 - position 58804536 (rs4326095 SNP) alleles are "GA"?
```
$$
\textrm{odds if GA} = \frac{\textrm{breast cancer|GA}}{\textrm{no breast cancer|GA}} 
$$
$$
\textrm{odds if GC or AT} = \frac{\textrm{breast cancer|GC or AT}}{\textrm{no breast cancer|GC or AT}}
$$
$$
\textrm{odds ratio} = \frac{\textrm{odds if GA}}{\textrm{odds if GC or AT}} = 1.4084 
$$


```r
SNP_data <- readr::read_csv("data/SNPv2.csv")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   `SNP ID` = col_character(),
##   `P-value` = col_double(),
##   `Chr ID` = col_double(),
##   `Chr Position` = col_double(),
##   `Submitted SNP ID` = col_character(),
##   Allele1 = col_character(),
##   Allele2 = col_character(),
##   `pHWE (case)` = col_double(),
##   `pHWE (control)` = col_double(),
##   `Call rate (case)` = col_double(),
##   `Call rate (control)` = col_double(),
##   `Odds ratio` = col_double()
## )
```

```r
SNP_data <- janitor::clean_names(SNP_data)
glimpse(SNP_data) #Association between a single SNP and breast cancer susceptibility in a group of 1,145 breast cancer patients and 1,142 controls.
```

```
## Rows: 422
## Columns: 12
## $ snp_id            <chr> "rs6549198", "rs13066342", "rs12152436", "rs6549200"~
## $ p_value           <dbl> 0.4059157, 0.3738323, 0.2996095, 0.5715863, 0.567541~
## $ chr_id            <dbl> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3~
## $ chr_position      <dbl> 69362958, 69369295, 69370395, 69373073, 69375654, 69~
## $ submitted_snp_id  <chr> "ss67470305", "ss67055138", "ss66986565", "ss6747030~
## $ allele1           <chr> "A", "C", "C", "T", "C", "A", "T", "A", "A", "A", "C~
## $ allele2           <chr> "G", "A", "T", "G", "T", "G", "G", "G", "G", "G", "T~
## $ p_hwe_case        <dbl> 0.6186, 0.8940, 0.5629, 1.0000, 0.7863, 0.3954, 1.00~
## $ p_hwe_control     <dbl> 0.8746, 0.2215, 0.7910, 1.0000, 0.6156, 0.6674, 0.90~
## $ call_rate_case    <dbl> 0.9991266, 0.9834061, 1.0000000, 1.0000000, 1.000000~
## $ call_rate_control <dbl> 0.9973730, 0.9912434, 1.0000000, 1.0000000, 1.000000~
## $ odds_ratio        <dbl> 0.9217, 1.1340, 1.0543, 0.8855, 0.9114, 1.0380, 0.91~
```

```r
SNP_data %>%
  arrange(desc(odds_ratio))
```

```
## # A tibble: 422 x 12
##    snp_id      p_value chr_id chr_position submitted_snp_id allele1 allele2
##    <chr>         <dbl>  <dbl>        <dbl> <chr>            <chr>   <chr>  
##  1 rs12581238 0.00414      12     22976812 ss67021887       T       C      
##  2 rs4326095  0.000626      5     58804536 ss67327073       G       A      
##  3 rs4551023  0.000574      5     58801290 ss67345223       C       T      
##  4 rs7728286  0.00206       5     58818721 ss67823328       C       T      
##  5 rs7733296  0.00492       5     58838137 ss67823910       T       C      
##  6 rs11653892 0.0426       17     48510879 ss66941285       A       G      
##  7 rs7712329  0.00291       5     58815659 ss67821192       C       T      
##  8 rs9843168  0.00755       3     69513197 ss67951107       C       T      
##  9 rs9458781  0.0130        6    163721183 ss67919497       A       G      
## 10 rs1870077  0.0109        5     58834851 ss67201344       A       G      
## # ... with 412 more rows, and 5 more variables: p_hwe_case <dbl>,
## #   p_hwe_control <dbl>, call_rate_case <dbl>, call_rate_control <dbl>,
## #   odds_ratio <dbl>
```



```r
SNP_data %>%
  group_by(chr_id) %>%
  summarise(n_distinct(snp_id))
```

```
## # A tibble: 21 x 2
##    chr_id `n_distinct(snp_id)`
##  *  <dbl>                <int>
##  1      1                   61
##  2      2                   28
##  3      3                   47
##  4      4                   21
##  5      5                   40
##  6      6                   21
##  7      7                   18
##  8      8                   18
##  9      9                   14
## 10     10                   15
## # ... with 11 more rows
```


```r
SNP_data %>%
  ggplot(aes(x = chr_id, y=n_distinct(snp_id))) +
  labs(title = "Distribution of SNPs",
       x = "Chromosome",
       y = "SNP count")+ theme_stata()+
  theme(axis.text.x = element_text(hjust = 1))+
  geom_col(fill="green",color="black")+
  scale_x_continuous(breaks = seq(1, 21, by = 1))
```

![](BIS15LFinalOmar_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
SNP_data %>% 
  ggplot(aes(x=chr_id, fill=n_distinct(snp_id))) + geom_density(alpha=.4)
```

![](BIS15LFinalOmar_files/figure-html/unnamed-chunk-6-2.png)<!-- -->



```r
SNP_data_causal <- SNP_data %>%
  filter(p_value<0.1)%>% #p-value from HWE testing in cases of breast cancer
  group_by(chr_id) %>%
  summarise(n_distinct(snp_id))
```


```r
SNP_data_causal %>%
  ggplot(aes(x = chr_id, y=`n_distinct(snp_id)`)) +
  labs(title = "Distribution of SNPs with p-value <0.1",
       x = "Chromosome",
       y = "SNP count")+ theme_stata()+
  theme(axis.text.x = element_text(hjust = 1))+
  geom_col(fill="pink",color="black")
```

![](BIS15LFinalOmar_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


```r
### MANHATTAN GRAPH - too advanced to draw by hand ###
don <- gwasResults %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(gwasResults, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( Chromosome=BP+tot) %>%

  # Add highlight and annotation information
  mutate( is_highlight=ifelse(SNP %in% snpsOfInterest, "yes", "no")) %>%
  mutate( is_annotate=ifelse(-log10(P)>4, "yes", "no")) 

# Prepare X axis
axisdf <- don %>% group_by(CHR) %>% summarize(center=( max(Chromosome) + min(Chromosome) ) / 2 )

# Make the plot
ggplot(don, aes(x=Chromosome, y=-log10(P))) +
    
    # Show all points
    geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
    scale_color_manual(values = rep(c("grey", "skyblue"), 22 )) +
    
    # custom X axis:
    scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
    scale_y_continuous(expand = c(0, 0) ) +     # remove space between plot area and x axis

    # Add highlighted points
    geom_point(data=subset(don, is_highlight=="yes"), color="orange", size=2) +

    # Custom the theme:
    theme_bw() +
    theme( 
      legend.position="none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank()
    )
```

![](BIS15LFinalOmar_files/figure-html/unnamed-chunk-9-1.png)<!-- -->
