fun rmLast(L) =
if tl(L)=[] then nil
else hd(L)::rmLast(tl(L));

fun findWidth(L) =
if L=[] then 0
else 1 + findWidth(tl(L));

fun findMax(L, max) =
if L=[] then max
else if hd(L) > max then findMax(tl(L), hd(L))
else findMax(tl(L), max);

fun findHeight(L, num, max) =
if L=[] then max
else if hd(L)=0 then findHeight(tl(L), num + 1, num + 1 ::max)
else findHeight(tl(L), num - 1, max);

fun getOuterArea(L) = findMax(findHeight(L, 0, []),0) * (findWidth(L) - 1);

fun getInnerArea(L, R, count, found) =
if count = 0 andalso found=1 then (L, R)
else if hd(L)=0 then getInnerArea(tl(L), R@[hd(L)], count + 1, 1)
else getInnerArea(tl(L), R@[hd(L)], count - 1, 1);

fun combineInner(L) =
if L=[] then []
else #2(getInnerArea(L, [], 0, 0)) :: combineInner(#1(getInnerArea(L, [], 0, 0)));

fun addAreas(L) =
if L=[] then 0
else getOuterArea(hd(L)) + addAreas(tl(L));

fun bracketsHelper(L, dark) =
if L=[] then 0
else if dark=true then getOuterArea(L) - addAreas(combineInner(rmLast(tl(L)))) + recurse(combineInner(rmLast(tl(L))), false)
else recurse(combineInner(rmLast(tl(L))), true)
and
recurse(L, bound) =
if L=[] then 0
else bracketsHelper(hd(L), bound) + recurse(tl(L), bound);

fun recursiveCall(L) =
if L=[] then 0
else bracketsHelper(hd(L), true) + recursiveCall(tl(L));

fun brackets(L) =
if L=[] then 0
else recursiveCall(combineInner(L));
