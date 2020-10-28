program ftngame;

uses  crt {color}, keyboard {read a key}, dos {time}, sysutils {files};

const
maxlvl=10;
minlvl=2;
MAX2=3; {number of score saved}

type tab=array [1..maxlvl,1..maxlvl+1] of integer;

Type score=record
nametemps:array[minlvl..maxlvl,1..MAX2] of string;
scoretemps:array[minlvl..maxlvl,1..MAX2] of longint;
namecoups:array[minlvl..maxlvl,1..MAX2] of string;
scorecoups:array[minlvl..maxlvl,1..MAX2] of integer;
end;



procedure EnregistrementDesScores(lvl,nbrmove:integer; t2:longint); 

var tabscore:score;
	pseudo:string;
	i,j:integer;
	classement:file of score;

begin
if (lvl>minlvl-1) and (lvl<maxlvl+1) then
begin
if not(FileExists('fichierscoresftngame')) then
	Begin
	{creation du fichier score}
	assign(classement, 'fichierscoresftngame');
	rewrite(classement);
		
	for i:=1 to MAX2 do
		for j:=minlvl to maxlvl do
		begin
		tabscore.scoretemps[j,i]:=10000;
		tabscore.scorecoups[j,i]:=10000;
		tabscore.nametemps[j,i]:='user';
		tabscore.namecoups[j,i]:='user';
		end;
	write(classement,tabscore);		
	close(classement);
	end;

assign(classement, 'fichierscoresftngame');
reset(classement);
Read(classement, tabscore);

if (t2<tabscore.scoretemps[lvl,MAX2]) then {for the time}
begin
rewrite(classement);
write('Good time ! pseudo : ');
Readln(pseudo);
i:=MAX2;
repeat
	if (t2<tabscore.scoretemps[lvl,i-1]) then
	begin
	tabscore.scoretemps[lvl,i]:=tabscore.scoretemps[lvl,i-1];
	tabscore.nametemps[lvl,i]:=tabscore.nametemps[lvl,i-1];
	i:=i-1;
	end;
until (t2>=tabscore.scoretemps[lvl,i-1]) or (i=1);

tabscore.scoretemps[lvl,i]:=t2;
tabscore.nametemps[lvl,i]:=pseudo;
write(classement, tabscore);
end;

if (nbrmove<tabscore.scorecoups[lvl,MAX2]) then {for the number of moves}
begin
rewrite(classement);
write('Good efficiency ! Pseudo : ');
Readln(pseudo);
i:=MAX2;
repeat
	if (nbrmove<tabscore.scorecoups[lvl,i-1]) then
	begin
	tabscore.scorecoups[lvl,i]:=tabscore.scorecoups[lvl,i-1];
	tabscore.namecoups[lvl,i]:=tabscore.namecoups[lvl,i-1];
	i:=i-1;
	end;
until (nbrmove>=tabscore.scorecoups[lvl,i-1]) or (i=1);

tabscore.scorecoups[lvl,i]:=nbrmove;
tabscore.namecoups[lvl,i]:=pseudo;
write(classement, tabscore);
end;
close(classement);
end;
End;



procedure AffichageDesScores(var lvl:integer);

var classement:file of score;
	i,j,l,c,pos,sec,cent:integer;
	K:TKeyEvent;
	tabscore:score;
Begin
clrscr;
assign(classement, 'fichierscoresftngame');
reset(classement);
Read(classement, tabscore);

repeat
write('Witch level do you want to check ? (beween ',minlvl,' to ',maxlvl,') ');
read(l);
If ((l<minlvl) or (l>maxlvl)) then
begin
clrscr;
writeln(l,' is not between ',minlvl,' and ',maxlvl,'.');
end;
until (l>minlvl-1) and (l<maxlvl+1);
writeln('');
for i:=1 to MAX2 do
begin
if (tabscore.nametemps[l,i]<>'user') then
	begin
	sec:=tabscore.scoretemps[l,i] div 100;
	cent:=tabscore.scoretemps[l,i]-(sec*100);
	if cent<10 then write(i,'- ',tabscore.nametemps[l,i],' : ',sec,',0',cent,' sec / ')
	else write(i,'- ',tabscore.nametemps[l,i],' : ',sec,',',cent,' sec / ');
	end;
end;
writeln('');
for i:=1 to MAX2 do
begin
if (tabscore.namecoups[l,i]<>'user') then write(i,'- ',tabscore.namecoups[l,i],' : ',tabscore.scorecoups[l,i],' moves / ');
end;
close(classement);

writeln('');
writeln('');
{list of differents choices}
writeln('Reset score [ ]');
writeln('Menu        [ ]');
writeln('Exit        [ ]');
writeln('');
writeln('Press SPACEBAR to select.');
pos:=wherey;
gotoxy(14,wherey-5);
c:=1;
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if ((KeyEventToString(K) = 'Up') and (wherey>pos-5)) then	GotoXY(14,wherey-1);
if ((KeyEventToString(K) = 'Down') and (wherey<pos-3))then	GotoXY(14,wherey+1);
c:=wherey;
until (KeyEventToString(K) = ' ');


DoneKeyBoard();
if (c=pos-5) then
begin
	assign(classement, 'fichierscoresftngame');
	reset(classement);
	rewrite(classement);
	for i:=1 to MAX2 do
		for j:=minlvl to maxlvl do
		begin
		tabscore.scoretemps[j,i]:=10000;
		tabscore.scorecoups[j,i]:=10000;
		tabscore.nametemps[j,i]:='user';
		tabscore.namecoups[j,i]:='user';
		end;
	write(classement,tabscore);
	close(classement);
	lvl:=1;
end;
if (c=pos-3) then lvl:=0;
if (c=pos-4) then lvl:=1;
End;

procedure menu(var gogame,goscore,gorules:boolean);
var c:integer;
	K:TKeyEvent;

Begin
InitKeyBoard();
gogame:=false;
goscore:=false;
gorules:=false;

clrscr;
writeln('15GAME by Ariadni, Luc, William');
writeln('');
{list of differents choices}
writeln('Play           [ ]');
writeln('Consult scores [ ]');
writeln('Consult rules  [ ]');
writeln('');
writeln('Press SPACEBAR to select.');
gotoxy(17,3);
c:=1;

repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if ((KeyEventToString(K) = 'Up') and (wherey>3)) then	GotoXY(17,wherey-1);
if ((KeyEventToString(K) = 'Down') and (wherey<5))then	GotoXY(17,wherey+1);
c:=wherey;
until (KeyEventToString(K) = ' ');

DoneKeyBoard();
if (c=3) then gogame:=true;
if (c=4) then goscore:=true;
if (c=5) then gorules:=true;
clrscr;
End;

procedure chooselevel(var lvl:integer);

begin
repeat
write('Choose a level between ',minlvl,' and ',maxlvl,' (0 to exit, 1 to return to menu) : ');
readln(lvl);

If lvl=0 then
begin
writeln('Good by ! =D');
exit;
end;

If lvl=1 then exit;

clrscr;
If ((lvl<minlvl) or (lvl>maxlvl)) then writeln(lvl,' is not between 2 and ',maxlvl,' : ');
until ((lvl>1) and (lvl<maxlvl+1));
end;



procedure grid(lvl:integer; var tab1:tab);

var col,lin:integer;

begin
for col:=1 to lvl do
for lin:=1 to lvl do
tab1[col,lin]:=col+lvl*(lin-1);
tab1[lvl,lvl]:=0;
end;



procedure scramble(lvl:integer; var col,lin:integer;var tab1:tab);

var i,x,abs,ord,s:integer;

begin
col:=lvl;
lin:=lvl;
x:=0;
s:=10*(6+(lvl-3)*(lvl-3)+9*(lvl-2));

randomize;


for i:=1 to s do
begin
repeat
abs:=random(3)-1;
if abs=0 then ord:=random(3)-1;
{condition to stay in the grid, to move in a case on a side not the previous one}
until ((col+abs>0) and (col+abs<lvl+1) and (lin+ord>0) and (lin+ord<lvl+1)
	and ((abs<>0) or (ord<>0)) and ((abs=0) or (ord=0)) and (tab1[col+abs,lin+ord]<>x));

tab1[col,lin]:=tab1[col+abs,lin+ord];
tab1[col+abs,lin+ord]:=0;
x:=tab1[col,lin];
col:=col+abs;
lin:=lin+ord;
end;
end;



procedure display(lvl:integer; tab1:tab);

var col,lin:integer;

begin
clrscr;

for lin:=1 to lvl do
begin
for col:=1 to lvl do
begin
if tab1[col,lin]<>0 then
begin
{for numbers <10, to keep the same spacing}
if tab1[col,lin] mod 2=0 then textbackground(red);
if (tab1[col,lin]<10) and (tab1[col,lin]>0) then write ('0');
{return to the line}
if col=lvl then writeln (tab1[col,lin],' ')
else write (tab1[col,lin],' ');
end 

else if col=lvl then writeln ('')
else write ('   ');
textbackground(black);
end;
end;
end;


procedure move(lvl:integer; var col,lin:integer; var tab1:tab);

var i:integer;
	ch:string;

begin
repeat
ch:=readkey;
i:=ord(ch[1]);

if (i=80) and (lin>1) then {go up a number}
begin
tab1[col,lin]:=tab1[col,lin-1];
tab1[col,lin-1]:=0;
lin:=lin-1;
end
else if (i=72) and (lin<lvl) then {go down a number}
	begin
	tab1[col,lin]:=tab1[col,lin+1];
	tab1[col,lin+1]:=0;
	lin:=lin+1;
	end
else if (i=77) and (col>1) then {go left a number}
	begin
	tab1[col,lin]:=tab1[col-1,lin];
	tab1[col-1,lin]:=0;
	col:=col-1;
	end
else if (i=75) and (col<lvl) then {go right a number}
	begin
	tab1[col,lin]:=tab1[col+1,lin];
	tab1[col+1,lin]:=0;
	col:=col+1;
	end
		
until (i=72) or (i=75) or (i=77) or (i=80);
end;


procedure check(lvl:integer; tab1:tab; var victory:boolean);

var col,lin:integer;

begin
victory:=true;
if tab1[lvl,lvl]=0 then tab1[lvl,lvl]:=lvl*lvl;
for col:=1 to lvl do
begin
for lin:=1 to lvl do
begin
if tab1[col,lin]<>col+lvl*(lin-1) then victory:=false;
end;
end;
end;



procedure stopwatch(t:longint; var sec,cent:integer; var t2:longint);

var t1:longint;
	h,m,s,c:word;

begin
gettime (h,m,s,c);
t1:=(h*36000+m*6000+s*100+c);
t2:=t1-t;
sec:=(t2 div 100);
cent:=(t2-100*sec);
end;



procedure rules (var lvl:integer);

const l=4;
var tab1:tab;
	pos,c:integer;
	K:TKeyEvent;

begin
clrscr;
grid(l,tab1);
display(l,tab1);
writeln('');
writeln('You want this.');
writeln('');
writeln('Menu [ ]');
writeln('Exit [ ]');
writeln('');
writeln('Press SPACEBAR to select.');
pos:=wherey;
gotoxy(7,pos-4);
c:=1;
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if ((KeyEventToString(K) = 'Up') and (wherey>pos-4)) then	GotoXY(7,wherey-1);
if ((KeyEventToString(K) = 'Down') and (wherey<pos-3))then	GotoXY(7,wherey+1);
c:=wherey;
until (KeyEventToString(K) = ' ');

DoneKeyBoard();
if (c=pos-4) then lvl:=1;
if (c=pos-3) then lvl:=0;
end;



procedure game(lvl:integer; var nbrmove:integer; var t2:longint);

var col,lin:integer;
	sec,cent:integer;
	t:longint;
	tab1:tab;
	victory:boolean;
	h,m,s,c:word;

begin
clrscr;
nbrmove:=0;

if ((lvl>minlvl-1) and (lvl<maxlvl+1)) then
begin
grid(lvl,tab1);
scramble(lvl,col,lin,tab1);

display(lvl,tab1);
writeln(' ');
writeln('00,00 sec');
writeln('Number of move : 0');
move(lvl,col,lin,tab1);
gettime (h,m,s,c);
t:=(h*36000+m*6000+s*100+c);
nbrmove:=nbrmove+1;

repeat {for each move}
{for the stopwatch and the number of move}
stopwatch(t,sec,cent,t2);
display(lvl,tab1);
writeln(' ');
write(sec,',', cent,' sec');
writeln('');

if nbrmove<2 then writeln('Number of move : ', nbrmove)
else writeln('Number of moves : ', nbrmove);
move(lvl,col,lin,tab1);
check(lvl,tab1,victory);
nbrmove:=nbrmove+1;
until (victory=true);

{to stop the time}
stopwatch(t,sec,cent,t2);
{to display the final grid ans the scores}
display(lvl,tab1);
writeln('');
textcolor(green);
if cent<10 then write(sec,',0',cent,' sec')
else write(sec,',',cent,' sec');
textcolor(white);
writeln('');
if nbrmove<2 then writeln('Number of move : ', nbrmove)
else writeln('Number of move : ', nbrmove);
Writeln('Puzzle solved !');
writeln('');
end;
end;


//main program

var lvl,nbrmove:integer;
var t2:longint;
var gogame,goscore,gorules:boolean;

begin
repeat
menu(gogame,goscore,gorules);
if goscore then AffichageDesScores(lvl);
if gorules then rules(lvl); 
if gogame then
begin
repeat
chooselevel(lvl);
game(lvl,nbrmove,t2);
EnregistrementDesScores(lvl,nbrmove,t2);
until (lvl=1) or (lvl=0);
end;
until (lvl=0);
end.
