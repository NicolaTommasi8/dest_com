# dest_com
Comando Stata che converte i nomi dei comuni italiani nel codice numerico ufficiale ISTAT.
Per maggiori informazioni leggi il file [dest_com.pdf](https://github.com/NicolaTommasi8/dest_com/blob/master/dest_com.pdf)



Autore
------
  **Nicola Tommasi**  
  _nicola.tommasi@gmail.com_     

  
Changelog
*! Nicola Tommasi
*! nicola.tommasi@univr.it
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
*!   eliminazione di codebook, problems che per dataset molto numerosi poteva allungare i tempi di esecuzione
*!   il label della variabile con i codici dei comuni corrisponde al nome della variabile stessa
*! version 0.0.1  TomaHawk  27aug2014

