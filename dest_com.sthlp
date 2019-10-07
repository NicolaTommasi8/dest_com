{smcl}
{* *! version 3.3  jan2019}{...}
{cmd:help dest_com}
{hline}


{title:Version}
3.3  January 2019



{title:Description}
{p2colset 5 15 17 2}{...}
{p2col :{cmd:dest_com}} converte i nomi dei comuni italiani nel rispettivo codice numerico ISTAT.{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 14 2}
{opt dest_com} {it:varname} {ifin} {cmd:,} {opt gen:erate(varname)} {opt time(varname)} [ {opt mkc(varname)} {opt ignore} {opt onlylab}  {opt gprov(varname)} {opt gregio(name)} {opt macro3(name)}
  {opt macro5(name)} {opt gnuts3(name)} {opt gnuts2(name)} {opt gnuts1(name)} ]


{pstd}
dove {it:varname} è la variabili stringa con i nomi dei comuni.
{p_end}

{synoptset 20 tabbed}{...}
{marker options}{...}
{synopthdr}
{synoptline}
{p2coldent : {opt gen:erate(varname)}} crea la variabile numerica {cmd:varname} con il codice ISTAT del comune. Se non specificato verrà creata di default la variabile {cmd:cod_com}.{p_end}
{p2coldent : {opt mkc(varname)}} variabile numerica con i codici ISTAT delle provincie. Serve per risolvere i casi di omonimia (vedi {title:Remarks}).{p_end}
{p2coldent : {opt ignore}} {opt dest_com} esegue due controlli. Il primo controlla che tutte le stringhe di {it: varname} siano riconosciute e quindi convertite in codice numerico,
il secondo controllo verifica che tutti i codici numerici generati abbiano una label. Se uno dei due controlli non è verificato, l'esecuzione del comando
viene interrota e nessuna conversione viene eseguita. Specificando l'opzione {opt ignore}, {opt dest_com} viene eseguito anche se uno dei controlli
non viene superato.{p_end}
{p2coldent : {opt onlylab}} questa opzione serve se la variabile è già numerica e l'operazione da compiere è solo il label dei suoi valori.{p_end}
{p2coldent : {opt time(varname)}} alcuni comuni a partire dal 2016 hanno mantenuto lo stesso nome ma hanno cambiato il codice istat a seguito di unione con un altro/i comune/i. Per assegnare
il codice ISTAT corretto è necessario specificare la variabile con l'anno a cui si riferiscono i dati. Vedi Remarks per ulteriori chiarimenti. Se questa variabile non viene specificata, di default
si assume che l'anno di riferimento sia il 2015.{p_end}
{p2coldent : {opt gprov(varname)}} genera una variabile con i codici ISTAT delle province.{p_end}
{p2coldent : {opt gregio(varname)}} genera una variabile con i codici ISTAT delle regioni.{p_end}
{p2coldent : {opt macro3(varname)}} genera una variabile con l'appartenenza a 3 macro regioni (Nord, Centro, Sud e Isole).{p_end}
{p2coldent : {opt macro5(varname)}} genera una variabile con l'appartenenza a 5 macro regioni (Nord-Ovest, Nord-Est, Centro, Sud, Isole).{p_end}
{p2coldent : {opt gnuts3(varname)}} genera una variabile (stringa) con i codici NUTS3 2010.{p_end}
{p2coldent : {opt gnuts2(varname)}} genera una variabile (stringa) con i codici NUTS2 2010.{p_end}
{p2coldent : {opt gnuts1(varname)}} genera una variabile (stringa) con i codici NUTS1 2010.{p_end}
{synoptline}
{p2colreset}{...}



{title:Examples}

{pstd}
codifica la variabile stringa {cmd:comune} nella variabile numerica {cmd:com_num}:{p_end}
{phang2}{cmd:. dest_com comune, gen(com_num) time(anno)}
{p_end}

{pstd}
come la precedente, ma i casi di omonimia vengono risolti con l'ausilio della variabile {cmd:prov_num}:{p_end}
{phang2}{cmd:. dest_com comune, gen(com_num) time(anno) mkc(prov_num)}


{title:Saved results}
{pstd}
Nessun risultato salvato



{title:Remarks}
{pstd}Esistono comuni con uguale denominazione presenti in provincie diverse. Per risolvere questi casi deve esistere una variabile con il codice della provincia
e questa deve essere indicata nell'opzione {opt mkc(varname)}. Se {opt mkc(varname)} non viene specificata viene assegnato il codice di default.{p_end}
{pstd}Questi sono i casi di omonimia:{p_end}
                                                           default
{cmd:Brione}         Brescia (17030)    Trento (22028)             17030
{cmd:Calliano}       Asti (5014)        Trento (22035)              5014
{cmd:Castro}         Bergamo (16065)    Lecce (75096)              16065
{cmd:Livio}          Como (13130)       Trento (22106)             13130
{cmd:Peglio}         Como (13178)       Pesaro Urbino (41041)      13178
{cmd:Samone}         Torino (1235)      Trento (22165)              1235
{cmd:Valverde}       Pavia (18170)      Catania (87052)            18170
{cmd:San Teodoro}    Messina (83090)    Olbia Tempio (104023)      83090


{pstd}A partire dal 2016 alcuni comuni hanno mantenuto lo stesso nome ma hanno cambiato il codice istat a seguito di unione con un altro/i comune/i.{p_end}
{pstd}Questi sono i casi:
{cmd:Campiglia Cervo} ha codice 96011 fino al 2015, assume codice 96086 a partire dal 2016.
{cmd:Lessona} ha codice 96029 fino al 2015, assume codice 96085 a partire dal 2016.




{title:References}
{phang}
ISTAT {browse "http://www.istat.it/it/archivio/6789": Pagina di riferimento}



{title:Author}

{pstd}Nicola Tommasi{p_end}
{pstd}Centro Interdipartimentale di Documentazione Economica (C.I.D.E.){p_end}
{pstd}University of Verona, Italy{p_end}
{pstd}nicola.tommasi@univr.it{p_end}
{pstd} {p_end}


{p 7 14 2}Help:  {help dest_prov}{p_end}
