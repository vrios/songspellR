# ####  pacotes necessários:
# library(tuneR)
# library(seewave)
# library(soundgen)
# library(magrittr)
# library(purrr)
# library(data.table)
#
# # carregando as funções
# source("findSyllables.R") # encontra as sílabas
# # source("waveCutter.R")
#
# # lendo os arquivos
# # usar setwd() pra definir a pasta de trabalho
# files <- list.files(path=here::here("inst/extdata"),pattern = ".wav",full.names = T) ## lista todos os arquivos .wav no diretório
# f <- readWave(files[[1]])@samp.rate # pega o sampling rate do primeiro arquivo. todos os arquivos devem tem o mesmo sampling rate e bit rate
#
# ### pra ter uma idéia de como funciona, lendo um arquivo, calculando o envelope e mostrando a média do envelope e o threshold da sílaba
# wav <- readWave(files[1])
# wav = normalize(wav)
# wav <- ffilter(wav, from = 500, to = 15000, output = "Wave")
# sylThres <- 0.75
# env1 <- env(wav, plot = F) # o soundgen calcula um envelope suavizado usando windowLength e overlap, mas o principio é o mesmo
# plot(env1, type = "l")
# abline(h = mean(env1), col = "red") # amplitude média do envelope
# abline(h = mean(env1 * sylThres), col = "blue") # threshold de deteção, eventos acima desta linha, com duração superior a shortestSyl e separado por tempo superior a shortestPause irão ser considerados como "silabas
#
# ##### Encontrando as sílabas #####
# # os principais parametros a serem ajustado são  shortestPause, sylThres, windowLength, e overlap
# silabas <- findSyllables(
#   files = files, # pode ser um arquivo ou vários
#   samplingRate = f,
#   lowpass = 500, ## em Hz, o filtro é opcional, se a gravação já estiver editada não precisa
#   highpass = 22000,## em Hz, o filtro é opcional, se a gravação já estiver editada não precisa
#   plot.spectro = T, # plota spectrogramas com sílabas destacadas em vermelho para conferir a seleção
#   shortestPause = 25, ## em milissegundos, tempo mínimo entre uma sílaba e outra
#   shortestSyl = 10, # ## menor tempo do evento acústico que ele considera como sílaba
#   plot = F, # se produz ou não o plot de bursts do soundgen, desnecessário
#   sylThres = .65, # amplitude threshold for syllable detection (as a proportion of global mean amplitude of smoothed envelope)
#   windowLength = 20, # length (ms) used to produce the amplitude envelope)
#   overlap = 50 # overlap  window used to produce the amplitude envelope)
# )
#
# # verifique no diretorio os arquivo .tif com o resultado da seleção. se não bater com a inspeção visual, alterar sylThres
#
# ## objeto silabas contém um dataframe com as colunas "sound.files", "selec", "start", "end", o mesmo padrão do warbleR
# # sound.files é o arquivo original
# # selec é o número da sílaba na ordem que foi encontrada naquele arquivo
# # start e end são o inicio e o fim de cada sílabas, em segundos
#
# #salva o resultado em um arquivo
# write.csv(silabas,file= "silabas.csv",row.names = F)
#
# #### Cortando as sílabas em arquivos separados ####
# # cria um subdiretórto syllables, contendo um wav para cada sílaba, e um spectrograma, com um jpg pra cada sílaba
#
# sylFiles <- waveCutter(
#   X = silabas, ## o objeto resultado de findSyllables, ou um dataframe com a mesma estrutura
#   padding = 0.005, ## tempo em segundos a ser adicionado antes e depois de cada sílaba
#   units = "seconds", ##
#   lowpass = 500, ## filtros a serem aplicados antes de cortar os arquivos
#   highpass = 22000,
#   write.wavs = T, #salva os wavs de cada silaba em um diretorio separado
#   write.specs = T #salva os espectrogramas de cada silaba em um diretorio separado
# )
#
