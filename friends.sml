
fun addDistinct(L:  (int * int list) list, current) =
if L=[] then []
else if #1(hd(L)) = current then #2(hd(L)) @ addDistinct(tl(L), current)
else addDistinct(tl(L), current);

fun formMatrix(L:  (int * int list) list, num, current) =
if num=current then []
else (current, addDistinct(L, current)) :: formMatrix(L, num, current + 1);

fun initList(curr, numOfPeople, L) =
if curr=numOfPeople then L
else (curr, []) :: initList(curr + 1, numOfPeople, L);

fun findHost(adj: (int * int list) list, host) =
if #1(hd(adj)) = host then #2(hd(adj))
else findHost(tl(adj), host);

fun rmHost(L: (int * int list) list, host) =
if tl(L)=[] then []
else if #1(hd(L)) = host then hd(tl(L)) :: rmHost(tl(L), host)
else hd(L) :: rmHost(tl(L), host)

fun addVertex(adj, L, addTo) =
if L=[] then (addTo, findHost(adj, addTo))
else addVertex((addTo, hd(L) :: findHost(adj, addTo)) :: rmHost(adj, addTo), tl(L), addTo);

fun hostOnly(adj, host, node) =
[addVertex(adj, [host], node)] @ [addVertex(adj, [node], host)];

fun addMultiple(adj, L, node) =
if L=[] then []
else hostOnly(adj, hd(L), node) @ addMultiple(adj, tl(L), node);

fun buildNetwork(adj, numPeople, L: (int * int * int) list, con, curr) =
if curr=numPeople then adj
else if #3(hd(L))=0 then buildNetwork(formMatrix(hostOnly(adj, #2(hd(L)), #1(hd(L))) @ adj, numPeople, 0), numPeople, tl(L), con, curr + 1)
else if #3(hd(L))=1 then buildNetwork(formMatrix(addMultiple(adj, findHost(adj, #2(hd(L))), #1(hd(L))) @ adj,numPeople, 0), numPeople, tl(L), con, curr + 1)
else buildNetwork(formMatrix(addMultiple(adj, [#2(hd(L))] @ findHost(adj, #2(hd(L))), #1(hd(L))) @ adj, numPeople, 0), numPeople, tl(L), con, curr + 1)

fun addConf(L: (int * int list) list, con) =
if L=[] then []
else (#1(hd(L)), #2(hd(L)), hd(con)) :: addConf(tl(L), tl(con));

fun visitedNodes(numPeople, counter) =
if counter = numPeople  then []
else counter :: visitedNodes(numPeople, counter + 1);

fun contains(L, element, bool) =
if L=[] then bool
else if hd(L)=element then contains(tl(L), element, true)
else contains(tl(L), element, bool);

fun removeFrom(visited, L) =
if visited=[] then []
else if contains(L, hd(visited), false)=true then removeFrom(tl(visited), L)
else hd(visited) :: removeFrom(tl(visited), L);

fun getTuple(num, adj, counter) =
if counter = num then hd(adj)
else getTuple(num, tl(adj), counter + 1);

fun removeFromRet(adj, visited, L) =
if visited=[] then []
else if contains(L, hd(visited), false)=true then removeFromRet(adj, tl(visited), L)
else getTuple(hd(visited), adj, 0) :: removeFromRet(adj, tl(visited), L);

fun recurseNode(adj, current: int * int list * int, visited, sum) =
if visited=[] then sum :: []
else if not(removeFromRet(adj, visited, #1(current) :: #2(current))=[]) then echoResults(adj, removeFromRet(adj, visited, #1(current) :: #2(current)), current, removeFrom(visited, #1(current) :: #2(current)), sum + #3(current))
else recurseNode(adj, current, [], #3(current) + sum)
and
echoResults(adj, L, current, visited, sum) =
if L=[] then nil
else recurseNode(adj, hd(L), visited, sum) @ echoResults(adj, tl(L), hd(L), visited, sum);

fun getMaxValue(L, max) =
if L=[] then max
else if hd(L) > max then getMaxValue(tl(L), hd(L))
else getMaxValue(tl(L), max);

fun recurseProblem(R, L, visited, sum) =
if L=[] then []
else getMaxValue(recurseNode(R, hd(L), visited, 0), 0) :: recurseProblem(R, tl(L), visited, sum);

fun findHost(adj: (int * int list * int) list, host) =
if #1(hd(adj)) = host then #3(hd(adj))
else findHost(tl(adj), host);

fun sum(adj, L) =
if L=[] then 0
else findHost(adj, hd(L)) + sum(adj, tl(L));

fun getMax(adj, L) =
if L=[] then []
else sum(adj, hd(L)) :: getMax(adj, tl(L));

fun survey(numPeople, L: (int * int * int) list, con) =
if L=[] then 0
else getMaxValue(recurseProblem(addConf(formMatrix(buildNetwork(initList(0, numPeople, []), numPeople, L, con, 1), numPeople, 0), con), addConf(formMatrix(buildNetwork(initList(0, numPeople, []), numPeople, L, con, 1), numPeople, 0), con), visitedNodes(numPeople, 0), 0),0);
