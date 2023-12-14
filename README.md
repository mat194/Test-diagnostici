# Test-diagnostici

> "We balance probabilities and choose the most likely. It is the scientific use of the imagination."
>
> Sherlock Holmes, The Hound of the Baskervilles

Il procedimento diagnostico è fondato sulla probabilità e pervaso da incertezza: la probabilità che un paziente sia affetto da una determinata patologia muta continuamente sulla base delle informazioni disponibili.

Come definiamo la bontà di un test? Dal grado di certezza di presenza/assenza di diagnosi che ci fornisce nel momento in cui viene eseguito.

Nella pratica clinica applichiamo un ragionamento Bayesiano quando usiamo un test diagnostico: modifichiamo la probabilità pre-test (_prior probability_) ad una nuova probabilità di malattia sulla base dell'esito (_posterior probability_).

Un errore che si rischia di fare nella pratica clinica è di sovrastimare l'effetto predittivo di un risultato positivo, ignorando la probabilità pre-test di malattia.

## Sensibilità e Specificità

Nei nostri percorsi di studi ci è stato insegnato che si tratta di parametri intrinseci dei test. Il primo indica la probabilità di ottenere un test positivo in un soggetto veramente affetto da malattia, mentre il secondo indica la probabilità di un risultato vero negativo in un soggetto senza malattia (anche dette _probabilità condizionate_).

La sensibilità (_Sn_) è data da:

$$
P(T+|D+)=Sensibilità(Sn)
$$

La specificità (_Sp_) è data da:
$$
P(T-|D-)=Specificità(Sp)
$$
Nel caso in cui test e stato di malattia siano discordanti avremo, invece:
$$
P(T+|D-)=1-Sp=Falso\;positivo
$$
$$
P(T-|D+)=1-Sn=Falso\;negativo
$$
Il problema è che, quando applichiamo il test, non sappiamo il reale stato di malattia/non malattia del paziente (altrimenti perché testarlo?) e pertanto, in realtà, facciamo affidamento sui valori predittivi

|                        |                               |                              |       |
|------------------------|-------------------------------|------------------------------|-------|
|                        | **Presenza di malattia (D+)** | **Assenza di malattia (D-)** |       |
| **Test positivo (T+)** | Vero positivo (A)             | Falso positivo (B)           | A + B |
| **Test negativo (T-)** | Falso negativo (C)            | Vero negativo (D)            | C + D |
|                        | A + C                         | B + D                        |       |

: tabella di contigenza di un test diagnostico

In ogni cella della tabella di contingenza quello che facciamo è moltiplicare la probabilità di malattia (A e C) e probabilità di non malattia (B e D) ottenendo così i valori predditivi (A/(A+B) e D/(C+D))
$$
Valore\;preditivo\;positivo=\frac{Sn* Prev}{Sn*Prev + (1-Sp)*(1-Prev)}
$$
Vediamo come nella stima del valore predittivo positivo le caratteristiche intrinseche di un test (sensibilità ossia probabilità condizionata di test positivo se sono malato) sono moltiplicate per la probabilità marginale di avere la mattia (ossia la prevalenza o probabilità pre-test) ottenendo così la stima dei veri positivi. Il medesimo ragionamento viene applicato nel caso dei falsi positivi.

Secondo il teorema di Bayes, infatti i valori predittivi non sono altro che probabilità condizionate di malattia in caso di test positivi
$$
P(D+|T+)=Valore\;preditivo\:positivo
$$
$$
P(D-|T-)=Valore\;preditivo\;neagtivio
$$
Per il valore predittivo negativo facciamo un ragionamento analogo
$$
Valore\;preditivo\;negativo=\frac{Sp*(1-Prev)}{(1-Sn) * Prev + Sp * (1-Prev)}
$$
Esistono anche altri valori che implicitamente usiamo nella pratica clinica, per esempio quando facciamo riferimento all'alto valore predittivo negativo di un test stiamo anche valutando la probabilità che un paziente presenti davvero malattia stante un test negativo ossia C/(C+D)
$$
1-NPV= \frac{(1-Sn)*Prev}{(1-Sn)*Prev + Sp*(1-Prev)}
$$
