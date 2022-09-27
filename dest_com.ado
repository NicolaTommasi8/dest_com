capture program drop dest_com
program define dest_com, sortpreserve

*! Nicola Tommasi
*! nicola.tommasi@univr.it

if c(stata_version) >= 16 & c(processors_lic) > 1 version 16
else version 13

*! version 01.2022
*!   aggiornati i nuovi comuni del 2022

*! version 01.2021
*!   aggiornati i nuovi comuni del 2021

*! version 01.2020
*!   aggiornati i nuovi comuni del 2020
*!   generate() non è più obbligatoria per compatibilità con opzione onlylab

*! version 11.2019
*!   sistemati i cambi di provincia del 1992
*!   minor bugs correction

*! version 4.2019
*!   adesso i comuni che hanno cambiato provincia vengono correttamente riconosciuti
*!   completato il label dei nomi dei comuni
*!   se il comando viene lanciato su Stata 16MP dovrebbe essere più veloce
*!   minor bugs correction

*! version 3.2019
*!   aggiornati i nuovi comuni del 2019
*!   minor bugs correction

*! version 3.2018
*!   aggiornati i nuovi comuni del 2018
*!   minor bugs correction

*! version 3.2
*!   aggiornati i nuovi comuni del 2017

*! version 3.1
*!   Imposto Stata 13 come versione minima
*!   Uso della funzione ustrfrom() per risolvere problemi legati a database non in formato utf-8 (solo per Stata 14 e successivi  )

*! version 3.0
*!   aggiunte le opzioni per creare le variabili
*!     codice provincia istat (gprov)
*!     codice regione istat  (gregio)
*!     codice nuts3 (gnuts3)
*!     codice nuts2 (gnuts2)
*!     codice nuts1 (gnuts1)

*! version 2.5
*!   possibilità di fare solo il label dei valori quando la variabile è già numerica
*!   aggiunte le variazioni amministrative del 2016
*!   introdotta l'opzione time: x esempio Campiglia Cervo fino al 2015 ha codice 96011, dal 2016 ha codice 96086

*! version 2
*!   eliminata la  necessità di installare il comando unlabeld
*!   creazione file di help
*!   aggiornato elenco comuni al 30/01/2015

*! version 1.1.0  06nov2014 aggiunta opzione ignore

*! version 1.0.0  02oct2014
*!   tutte le variabili usate nel comando sono di tipo tempvar
*!   introduzione  di contract _CLONE e successivo merge
*!   di fatto parallel non serve più (eliminata la relativa opzione)
*!   correzioni nel riconoscimento di alcuni comuni
*!   eliminazione di codebook, problems che per dataset molto grandi poteva allungare i tempi di esecuzione
*!   il label della variabile con i codici dei comuni corrisponde al nome della variabile stessa

*! version 0.0.1  TomaHawk  27aug2014



syntax varlist (max=1) [if] [in], time(varname numeric min=1 max=1) [GENerate(name) ///
                                  mkc(varname numeric min=1 max=1) ignore onlylab gprov(name) gregio(name) macro3(name) macro5(name) gnuts3(name) gnuts2(name) gnuts1(name)]
marksample touse, strok
**check nv già esistente
**check varlist sia stringa
**check mkd esista e sia numerica



tempvar dups clone ID _CLONE _NV TIME
tempfile TMPF

**if "`time'" == "" assert "`onlylab'" == ""



local enda "end"
if "`onlylab'" != "" {
  assert "`generate'" == ""
  assert "`ignore'" == ""
  assert "`mkc'" == ""
  local nv = "`varlist'"
  capture label drop `nv'
  qui include "`c(sysdir_plus)'d/dest_com_lab.do"
  label values `nv' `nv'
  exit
}



if "`generate'" == "" local nv "cod_com"
else local nv "`generate'"
capture confirm variable `nv', exact
if !_rc {
  di "variable `nv' already exists"
  exit _rc
}


qui clonevar `_CLONE' = `varlist'
qui replace `_CLONE' = trim(`_CLONE')
qui replace `_CLONE' = lower(`_CLONE')

qui clonevar `TIME' = `time'



/***
qui findfile un_dest_com.ado, path(PERSONAL)
local comm_path = r(fn)
local comm_path: subinstr local comm_path "un_dest_com.ado" ""
***/

gen `ID' = _n
preserve
qui keep if `touse'
contract `_CLONE' `TIME' `mkc'
drop _freq

qui gen int `_NV' = .

if `c(stata_version)'>= 14 {
  tempvar sec_check_var
  gen `sec_check_var' = ustrfrom(`_CLONE', "utf-8", 4)
}

qui include "`c(sysdir_plus)'d/dest_com.do"


qui clonevar `nv' = `_NV'
drop `_NV'
**duplicates report `nv'
**duplicates tag `nv', gen(dups)
**list if dups>=1

rename `TIME' `time'

qui {
if "`mkc'" != "" {
  ***correzioni casi di omonimia che si possono risolvere solo se è presente la provincia
  **replace cod_com=22028 if cod_com==17030 & cod_prov==22
  replace `nv'=22028 if `mkc'==22 & `nv'==17030
  replace `nv'=22035 if `mkc'==22 & `nv'==5014
  replace `nv'=75096 if `mkc'==75 & `nv'==16065 /*castro*/
  replace `nv'=22106 if `mkc'==22 & `nv'==13130
  replace `nv'=41041 if `mkc'==41 & `nv'==13178 /*peglio*/
  replace `nv'=22165 if `mkc'==22 & `nv'==1235
  replace `nv'=87052 if `mkc'==87 & `nv'==18170
  replace `nv'=104023 if `mkc'==104 & `nv'==83090

  ***correzioni casi ambigui
  replace `nv' = 28041 if strmatch(`_CLONE',"gazzo") & `mkc'==28 /*gazzo padovano*/
  replace `nv' = 23037 if strmatch(`_CLONE',"gazzo") & `mkc'==23 /*gazzo veronese*/

  replace `nv' = 21112 if strmatch(`_CLONE',"verano") & `mkc'==21 /* verano */
  replace `nv' = 108048 if strmatch(`_CLONE',"verano") & `mkc'==108 /*verano brianza */

  replace `nv' = 13038 if `nv' == 22030 & `mkc'==13 /* cagno */
  replace `nv' = 22030 if `nv' == 13038 & `mkc'==22 /* cagn� */

  replace `nv' = 21026 if strmatch(`_CLONE',"corvara") & `mkc'==21

  }
}





if "`gprov'" != "" | "`gregio'" != "" | "`macro3'" != "" | "`macro5'" != "" | "`gnuts3'" != "" | "`gnuts2'" != "" | "`gnuts1'" != ""  {
tempvar tmpprov tmpregio
qui recode `nv' (1001/1999 = 1 "Torino") (2001/2999 = 2 "Vercelli") (3001/3999 = 3 "Novara") (4001/4999 = 4 "Cuneo") (5001/5999 = 5 "Asti") (6001/6999 = 6 "Alessandria") (96001/96999 = 96 "Biella") (103001/103999 = 103 "Verbano-Cusio-Ossola")   ///
            (7001/7999 = 7 "Aosta")  ///
            (8001/8999 = 8 "Imperia") (9001/9999 = 9 "Savona") (10001/10999 = 10 "Genova") (11001/11999 = 11 "La Spezia")  ///
            (12001/12999 = 12 "Varese") (13001/13999 = 13 "Como") (14001/14999 = 14 "Sondrio") (15001/15999 = 15 "Milano") (16001/16999 = 16 "Bergamo") (17001/17999 = 17 "Brescia") (18001/18999 = 18 "Pavia") (19001/19999 = 19 "Cremona") (20001/20999 = 20 "Mantova") (97001/97999 = 97 "Lecco") (98001/98999 = 98 "Lodi") (108001/108999 = 108 "Monza e della Brianza") ///
            (21001/21999 = 21 "Bolzano") (22001/22999 = 22 "Trento")  ///
            (23001/23999 = 23 "Verona") (24001/24999 = 24 "Vicenza") (25001/25999 = 25 "Belluno") (26001/26999 = 26 "Treviso") (27001/27999 = 27 "Venezia") (28001/28999 = 28 "Padova") (29001/29999 = 29 "Rovigo") ///
            (30001/30999 = 30 "Udine") (31001/31999 = 31 "Gorizia") (32001/32999 = 32 "Trieste") (93001/93999 = 93 "Pordenone") ///
            (33001/33999 = 33 "Piacenza") (34001/34999 = 34 "Parma") (35001/35999 = 35 "Reggio nell'Emilia") (36001/36999 = 36 "Modena") (37001/37999 = 37 "Bologna") (38001/38999 = 38 "Ferrara") (39001/39999 = 39 "Ravenna") (40001/40999 = 40 "Forlì-Cesena") (99001/99999 = 99 "Rimini") ///
            (41001/41999 = 41 "Pesaro e Urbino") (42001/42999 = 42 "Ancona") (43001/43999 = 43 "Macerata") (44001/44999 = 44 "Ascoli Piceno") (109001/109999 = 109 "Fermo") ///
            (45001/45999 = 45 "Massa-Carrara") (46001/46999 = 46 "Lucca") (47001/47999 = 47 "Pistoia") (48001/48999 = 48 "Firenze") (49001/49999 = 49 "Livorno") (50001/50999 = 50 "Pisa") (51001/51999 = 51 "Arezzo") (52001/52999 = 52 "Siena") (53001/53999 = 53 "Grosseto") (100001/100999 = 100 "Prato") ///
            (54001/54999 = 54 "Perugia") (55001/55999 = 55 "Terni")  ///
            (56001/56999 = 56 "Viterbo") (57001/57999 = 57 "Rieti") (58001/58999 = 58 "Roma") (59001/59999 = 59 "Latina") (60001/60999 = 60 "Frosinone") ///
            (61001/61999 = 61 "Caserta") (62001/62999 = 62 "Benevento") (63001/63999 = 63 "Napoli") (64001/64999 = 64 "Avellino") (65001/65999 = 65 "Salerno")  ///
            (66001/66999 = 66 "L'Aquila") (67001/67999 = 67 "Teramo") (68001/68999 = 68 "Pescara") (69001/69999 = 69 "Chieti") ///
            (70001/70999 = 70 "Campobasso") (94001/94999 = 94 "Isernia") ///
            (71001/71999 = 71 "Foggia") (72001/72999 = 72 "Bari") (73001/73999 = 73 "Taranto") (74001/74999 = 74 "Brindisi") (75001/75999 = 75 "Lecce") (110001/110999 = 110 "Barletta-Andria-Trani") ///
            (76001/76999 = 76 "Potenza") (77001/77999 = 77 "Matera") ///
            (78001/78999 = 78 "Cosenza") (79001/79999 = 79 "Catanzaro") (80001/80999 = 80 "Reggio di Calabria") (101001/101999 = 101 "Crotone") (102001/102999 = 102 "Vibo Valentia") ///
            (81001/81999 = 81 "Trapani") (82001/82999 = 82 "Palermo") (83001/83999 = 83 "Messina") (84001/84999 = 84 "Agrigento") (85001/85999 = 85 "Caltanisetta") (86001/86999 = 86 "Enna") (87001/87999 = 87 "Catania") (88001/88999 = 88 "Ragusa") (89001/89999 = 89 "Siracusa") ///
            (90001/90999 = 90 "Sassari") (91001/91999 = 91 "Nuoro") (92001/92999 = 92 "Cagliari") (95001/95999 = 95 "Oristano") (104001/104999 = 104 "Olbia-Tempio") (105001/105999 = 105 "Ogliastra") (106001/106999 = 106 "Medio Campidano") (107001/107999 = 107 "Carbonia-Iglesias") (111001/111999 = 111 "Sud Saregna") ///
            (*=.), gen(`tmpprov') label(`gprov')

qui recode `nv' (1001/1999 2001/2999 3001/3999 4001/4999 5001/5999 6001/6999  96001/96999 103001/103999 = 1 "Piemonte")   ///
            (7001/7999 = 2 "Valle d'Aosta")  ///
            (8001/8999 9001/9999 10001/10999 11001/11999 = 7 "Liguria")  ///
            (12001/12999 13001/13999 14001/14999 15001/15999 16001/16999 17001/17999 18001/18999 19001/19999 20001/20999 97001/97999 98001/98999 108001/108999 = 3 "Lombardia") ///
            (21001/21999 22001/22999 = 4 "Trentino-Alto Adige")  ///
            (23001/23999 24001/24999 25001/25999 26001/26999 27001/27999 28001/28999 29001/29999 = 5 "Veneto") ///
            (30001/30999 31001/31999 32001/32999 93001/93999 = 6 "Friuli-Venezia Giulia") ///
            (33001/33999 34001/34999 35001/35999 36001/36999 37001/37999 38001/38999 39001/39999 40001/40999 99001/99999 = 8 "Emilia-Romagna") ///
            (41001/41999 42001/42999 43001/43999 44001/44999 109001/109999 = 11 "Marche") ///
            (45001/45999 46001/46999 47001/47999 48001/48999 49001/49999 50001/50999 51001/51999 52001/52999 53001/53999 100001/100999 = 9 "Toscana") ///
            (54001/54999 55001/55999 = 10 "Umbria")  ///
            (56001/56999 57001/57999 58001/58999 59001/59999 60001/60999 = 12 "Lazio") ///
            (61001/61999 62001/62999 63001/63999 64001/64999 65001/65999 = 15 "Campania")  ///
            (66001/66999 67001/67999 68001/68999 69001/69999 = 13 "Abruzzo") ///
            (70001/70999 94001/94999 = 14 "Molise") ///
            (71001/71999 72001/72999 73001/73999 74001/74999 75001/75999 110001/110999 = 16 "Puglia") ///
            (76001/76999 77001/77999 = 17 "Basilicata") ///
            (78001/78999 79001/79999 80001/80999 101001/101999 102001/102999 = 18 "Calabria") ///
            (81001/81999 82001/82999 83001/83999 84001/84999 85001/85999 86001/86999 87001/87999 88001/88999 89001/89999 = 19 "Sicilia") ///
            (90001/90999 91001/91999 92001/92999 95001/95999 104001/104999 105001/105999 106001/106999 107001/107999 = 20 "Sardegna") ///
            (*=.), gen(`tmpregio')  label(`gregio')


if "`gprov'" != "" {
  clonevar `gprov' = `tmpprov'
  **list `nv' `gprov' if `gprov'==.
  qui assert `nv'==. if `gprov'==.
}

if "`gregio'" != "" {
  clonevar `gregio' = `tmpregio'
  qui assert `nv'==. if `gregio'==.
  label var `gregio' "Regione"
}

if "`macro3'" != "" {
  qui recode `tmpregio' (1/8=1 "Nord") (9/12=2 "Centro") (13/20=3 "Sud e Isole"), gen(`macro3')
  qui assert `nv'==. if `macro3'==.
  label var `macro3' "Macro Regioni"
  }

if "`macro5'" != "" {
  qui recode `tmpregio' (1 2 3 7=1 "Nord-Ovest") (4 5 6 8=2 "Nord-Est") (9/12=3 "Centro") (13/18=4 "Sud") (19 20=5 "Isole"), gen(`macro5')
  qui assert `nv'==. if `macro5'==.
  label var `macro5' "Macro Regioni"
  }

if "`gnuts3'" != "" {
  tempname labnuts3
  tempvar gnuts3num
  clonevar `gnuts3num' = `tmpprov'
  label define `labnuts3' 1 "ITC11" 2 "ITC12" 3 "ITC15"  4 "ITC16" 5 "ITC17" 6 "ITC18" 96 "ITC13" 103 "ITC14"   ///
            7 "ITC20" ///
            8 "ITC31"  9 "ITC32" 10 "ITC33" 11 "ITC34"  ///
            12 "ITC41" 13 "ITC42" 14 "ITC44" 15 "ITC4C" 16 "ITC46" 17 "ITC47" 18 "ITC48" 19 "ITC4A" 20 "ITC4B" 97 "ITC43" 98 "ITC49" 108 "ITC4D" ///
            21 "ITH10" 22 "ITH20" ///
            23 "ITH31" 24 "ITH32" 25 "ITH33" 26 "ITH34" 27 "ITH35" 28 "ITH36" 29 "ITH37" ///
            30 "ITH42" 31 "ITH43" 32 "ITH44" 93 "ITH41" ///
            33 "ITH51" 34 "ITH52" 35 "ITH53" 36 "ITH54" 37 "ITH55" 38 "ITH56" 39 "ITH57" 40 "ITH58" 99 "ITH59" ///
            41 "ITI31" 42 "ITI32" 43 "ITI33" 44 "ITI34" 109 "ITI35"  ///
            45 "ITI11" 46 "ITI12" 47 "ITI13" 48 "ITI14" 49 "ITI16" 50 "ITI17" 51 "ITI18" 52 "ITI19" 53 "ITI1A" 100 "ITI15" ///
            54 "ITI21" 55 "ITI22"  ///
            56 "ITI41" 57 "ITI42" 58 "ITI43" 59 "ITI44" 60 "ITI45" ///
            61 "ITF31" 62 "ITF32" 63 "ITF33" 64 "ITF34" 65 "ITF35"  ///
            66 "ITF11" 67 "ITF12" 68 "ITF13" 69 "ITF14" ///
            70 "ITF22" 94 "ITF21" ///
            71 "ITF46" 72 "ITF47" 73 "ITF43" 74 "ITF44" 75 "ITF45" 110 "ITF48" ///
            76 "ITF51" 77 "ITF52" ///
            78 "ITF61" 79 "ITF63" 80 "ITF65" 101 "ITF62" 102 "ITF64" ///
            81 "ITG11" 82 "ITG12" 83 "ITG13" 84 "ITG14" 85 "ITG15" 86 "ITG16" 87 "ITG17" 88 "ITG18" 89 "ITG19" ///
            90 "ITG25" 91 "ITG26" 92 "ITG27" 95 "ITG28" 104 "ITG29" 105 "ITG2A" 106 "ITG2B" 107 "ITG2C"
  label values `gnuts3num' `labnuts3'
  decode `gnuts3num', gen(`gnuts3')
  label var `gnuts3' "NUTS3 2010"
  drop `gnuts3num'
  }



if "`gnuts2'" != "" {
  tempname labnuts2
  tempvar gnuts2num
  clonevar `gnuts2num' = `tmpregio'
  qui replace `gnuts2num'=41 if `tmpprov' == 21
  qui replace `gnuts2num'=42 if `tmpprov' == 22
  label define `labnuts2' 1 "ITC1" 2 "ITC2" 3 "ITC4"  41 "ITH1" 42 "ITH2" 5 "ITH3" 6 "ITH4" 7 "ITC3" 8 "ITH5"   ///
            9 "ITI1" 10 "ITI2" 11 "ITI3" 12 "ITI4" 13 "ITF1" 14 "ITF2" 15 "ITF3" 16 "ITF4" 17 "ITF5" 18 "ITF6" ///
            19 "ITG1" 20 "ITG2"
  label values `gnuts2num' `labnuts2'
  decode `gnuts2num', gen(`gnuts2')
  label var `gnuts2' "NUTS2 2010"
  drop `gnuts2num'
  }



if "`gnuts1'" != "" {
    tempvar gnuts1num
  qui recode `tmpregio' (1 2 3 7 = 1 "ITC" ) (4 5 6 8 = 2 "ITH") (9 10 11 12 = 3 "ITI") (13 14 15 16 17 18 = 4 "ITF") (19 20 = 5 "ITG"), gen(`gnuts1num')
  decode `gnuts1num', gen(`gnuts1')
  label var `gnuts1' "NUTS1 2010"
  drop `gnuts1num'
  }

}



qui save `TMPF', replace
**save check, replace
restore
tempvar merge
qui merge m:1 `_CLONE' `time' `mkc' using `TMPF', assert(1 3) keepusing(`nv' `gprov' `gregio' `macro3' `macro5' `gnuts3' `gnuts2' `gnuts1') generate(`merge')
qui keep if inlist(`merge',1,3)
drop `merge'
sort `ID'
drop `ID'


capture label drop `nv'
qui include "`c(sysdir_plus)'d/dest_com_lab.do"
label values `nv' `nv'



order `nv', after(`varlist')



/*** CHECKS  ***/
local ERROR = 0

capture assert `nv'!=. if `_CLONE'!="" & `touse', fast
if _rc!=0 {
  local ERROR = 1
  di as error "Ci sono voci della variabile `varlist' non convertiti in numerici. Questa è la lista:"
  **fre `varlist' if `nv'==., all
  qui levelsof `varlist' if `nv'==. & `touse', local(lista)
  local cnt = 1
  foreach i of local lista {
	 di `"`cnt'. `i'"'
   local cnt `++cnt'
	}
}


qui count if `nv'==11020
if r(N)>0 di "Luni si chiamava Ortonovo fino ad aprile 2017"
qui count if `nv'==20061
if r(N)>0 di "Sermide e Felonica si chiamava Sermide fino a marzo 2017"
qui count if `nv'==23014
if r(N)>0 di "Brenzone sul Garda si chiamava Brenzone fino al 2013"
qui count if `nv'==65025
if r(N)>0 di "Capaccio Paestum si chiamava Capaccio fino a metà 2016"
qui count if `nv'==4051
if r(N)>0 di "Castellinaldo d'Alba si chiamava Castellinaldo fino al 2014"
qui count if `nv'==20057
if r(N)>0 di "San Giorgio Bigarello si chiamava San Giorgio di Mantova fino al 2018"




qui levelsof `nv', local(test)
foreach k of local test {
**set trace on
   if "`:label (`nv') `k', strict'" == "" {
   local ERROR = 1
   di as error "Ci sono delle categorie di `nv' senza label. Questa è la lista:"
   di _newline "Valore `k' senza label"
	 di "Associato a questi valori di `varlist'"
	 qui levelsof `varlist' if `nv'==`k', local(lista) clean
	 foreach i of local lista {
	 di `" `i' "'
	 }

   }
}



/*************
qui unlabeld `nv' if `nv'!=.
if $S_1==1 {
  local ERROR = 1
  di as error "Ci sono delle categorie di `nv' senza label. Questa è la lista:"
  unlabeld `nv'
}
****************/


drop `_CLONE'

if `ERROR'==1 & "`ignore'" == "" {
   di _newline "Non sono stati passati tutti i check!"
   di "Correggere i valori nella variabile `varlist', quindi riprovare. Oppure specifica l'opzione ignore"
   capture drop `nv'
   exit

}

label var `nv' "Codice ISTAT comune"

di "L'attribuzione del codice numerico sembra andata a buon fine, ma non ci può essere la certezza al 100%"
di "Usare i dati con attenzione!"

end
