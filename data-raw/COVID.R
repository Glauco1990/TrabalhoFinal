#### Ler arquivo ####

#covid_original <- readxl::read_xlsx(
#"data-raw/HIST_PAINEL_COVIDBR_06set2020.xlsx")

library(dplyr)

covid_original <- readr::read_rds(path = "data-raw/covid.rds")


#### Organizar ####

# Dados do covid.saude.gov.br / Sobre:

# Incidência = Estima o risco de ocorrência de casos de COVID-19 na população
# casos confirmados / populacao * 100.000

# Mortalidade = Número de óbitos por doenças COVID-19, por 100 mil habitantes
# óbitos / população * 100.000

# Letalidade = N. de óbitos confirmados em relação ao total de casos
# confirmados óbitos / casos confirmados * 100

# covid_original <- covid_original %>%
#   select(-codRegiaoSaude, -Recuperadosnovos,
#          -emAcompanhamentoNovos, -obitosAcumulado_log2, -obitosNovos_log2) %>%
#   mutate(
#     incidencia = casosAcumulado / populacaoTCU2019 * 100000,
#     mortalidade = obitosAcumulado / populacaoTCU2019 * 100000,
#     letalidade = obitosAcumulado / casosAcumulado * 100,
#   )

covid_original <- covid_original %>%
  select(-codRegiaoSaude, -Recuperadosnovos,
         -emAcompanhamentoNovos, -obitosAcumulado_log2, -obitosNovos_log2)

#### Dividir ####

# Nacional
covid_brasil <- covid_original %>%
  filter(regiao == "Brasil", is.na(estado), is.na(municipio))

# Por estado
covid_estado <- covid_original %>%
  filter(regiao != "Brasil", !is.na(estado), is.na(municipio))

# Por municipio
covid_municipio <- covid_original %>%
  filter(regiao != "Brasil", !is.na(estado), !is.na(municipio))

# Restringir SP

covid_sp <- covid_municipio %>%
  filter(estado == "SP")

#### Corrigir códigos ####

covid_sp <- covid_sp %>%
  left_join(y = select(abjData::cadmun, 1:2),
            by = c("codmun" = "MUNCOD"))

covid_sp <- covid_sp %>%
  mutate(code_muni = MUNCODDV) %>%
  select(-MUNCODDV, -codmun)


#### Exportar ####
# Apenas os dados de SP

readr::write_rds(covid_sp, "data/COVID-sp.rds")

