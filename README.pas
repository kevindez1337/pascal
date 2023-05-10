# pascal
program Minesweeper;

const
  Size = 9; // размер поля
  MinesCount = 10; // количество мин

type
  Field = array[1..Size, 1..Size] of integer;

var
  Board: Field; // игровое поле
  Mines: integer; // количество установленных мин

// заполнение поля
procedure FillBoard(var Board: Field);
var
  i, j: integer;
begin
  for i := 1 to Size do
    for j := 1 to Size do
      Board[i][j] := 0;
end;

// установка мин
procedure SetMines(var Board: Field);
var
  i, j, k: integer;
begin
  Randomize;
  Mines := 0;
  repeat
    i := Random(Size) + 1;
    j := Random(Size) + 1;
    if Board[i][j] <> -1 then
    begin
      Board[i][j] := -1;
      Inc(Mines);
    end;
  until Mines = MinesCount;
end;

// отображение поля
procedure ShowBoard(var Board: Field);
var
  i, j: integer;
begin
  for i := 1 to Size do
  begin
    for j := 1 to Size do
    begin
      case Board[i][j] of
        -1: write('*'); // мина
        0: write('.'); // пустая клетка
        else write(Board[i][j]); // количество мин вокруг
      end;
      write(' ');
    end;
    writeln;
  end;
end;

// подсчет количества мин вокруг клетки
function CountMinesAround(var Board: Field; x, y: integer): integer;
var
  i, j: integer;
begin
  Result := 0;
  for i := x - 1 to x + 1 do
    for j := y - 1 to y + 1 do
      if (i >= 1) and (i <= Size) and (j >= 1) and (j <= Size) and (Board[i][j] = -1) then
        Inc(Result);
end;

// открытие клетки
procedure OpenCell(var Board: Field; x, y: integer);
begin
  if (x < 1) or (x > Size) or (y < 1) or (y > Size) then
    Exit;
  if Board[x][y] > 0 then
    Exit;
  if Board[x][y] = -1 then
  begin
    writeln('Boom!');
    Halt;
  end;
  Board[x][y] := CountMinesAround(Board, x, y);
  if Board[x][y] = 0 then
  begin
    OpenCell(Board, x - 1, y - 1);
    OpenCell(Board, x - 1, y);
    OpenCell(Board, x - 1, y + 1);
    OpenCell(Board, x, y - 1);
    OpenCell(Board, x, y + 1);
    OpenCell(Board, x + 1, y - 1);
    OpenCell(Board, x + 1, y);
    OpenCell(Board, x + 1, y + 1);
  end;
end;

// игра
procedure Game;
var
  x, y: integer;
begin
  FillBoard(Board);
