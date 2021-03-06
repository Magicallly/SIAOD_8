unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Spin;
const
  ColorElemBrush = clWhite;
  ColorElemPen = clBlack;
  ColorElemText = clBlack;

  ColorPenArrow = clBlack;
  ColorBrushArrow = clWhite;
  ColorTextArrow = clBlack;
  DegreeArrow = Pi/10;
  LengthArrow = 12;
  ArroyWidth = 1;
  ShiftText = 36;
  DistanceFromCenter = 150;
  ShiftCenter = 50;

  Infinity = 1000000;
  RadiusElem = 20;
type
  TwoDimenMatrric = array of array of integer;
  OneDimenMatrric = array of integer;

  TLWayList = ^TWayList;

  TForm1 = class(TForm)
    gbGraphView: TGroupBox;
    imgGraphView: TImage;
    btnGraphPaint: TButton;
    lbFinishPoint: TLabel;
    lbStartPoint: TLabel;
    btnDoCalculation: TButton;
    lbTextMaxWay: TLabel;
    lbTextMinWay: TLabel;
    lbTextCenterGraph: TLabel;
    lbMaxWay: TLabel;
    lbMinWay: TLabel;
    lbCenterGraph: TLabel;
    mmAllWay: TMemo;
    lbAllWay: TLabel;
    OpenDialog1: TOpenDialog;
    seFinishPoint: TEdit;
    seStartPoint: TEdit;
    procedure FormCreate(Sender: TObject);
    //procedure seCountElemChange(Sender: TObject);
    procedure btnGraphPaintClick(Sender: TObject);
    procedure strgrAdjTabKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDoCalculationClick(Sender: TObject);
  private
    AdjTab:TwoDimenMatrric;
    CountElem:integer;

    procedure PaintTipArray(const x,y :integer; Direction:Real);
    procedure PaintArray(X1,Y1,X2,Y2 : integer;const leftTip,RightTip:boolean);
    procedure PaintText(const X,Y:integer;const ColorText,ColorBrush: TColor; const Text:string);
    procedure GetNewCord(var x, y: integer; const Direction:Real; const Length:real);
    function DegreeBetween(X1,Y1,X2,Y2 : real):real;
    procedure ClearImage;

    procedure PaintConnection(X1,Y1,X2,Y2, LengthLeft,LengthRight:integer);
    procedure PaintElem(const X1,Y1:integer; Text:string);

    function DeykstraAlgorithm(start: Byte; out Way:OneDimenMatrric):OneDimenMatrric;
    function FloidAlgorithm: TwoDimenMatrric;
    procedure PaintGraph;
    function GraphCenter(FloidRes: TwoDimenMatrric): Byte;overload;
    function GraphCenter:Byte;overload;

    //procedure SetCountElem(value:integer);
    function TranslateAdjTab:boolean;

    function FindWay:TLWayList;

    procedure DoCalculation;
    { Private declarations }
  public
    { Public declarations }
  end;

  UsedWayMn = Set of Byte;

  TWay = record
    Name : string;
    Used : UsedWayMn;
    Cost : Integer;
  end;

  TWayList = record
    Way:TWay;
    Next:TLWayList;
  end;

var
  Form1: TForm1;

implementation
Uses
  Math;
{$R *.dfm}

function NewList : TLWayList;
begin
  New(Result);
  Result^.Next:=nil;
end;

procedure AddToList(Way:TWay; var List:TLWayList);
var
  x:TLWayList;
begin
  x:=List;

  while x^.Next<> nil do
    x:=x^.Next;

  New(x^.Next);
  x^.Next^.Way:=Way;
  x^.Next^.Next:=nil;
end;

procedure AddToSortedList(Way:TWay; var List:TLWayList);
var
  x,y:TLWayList;
begin
  x:=List;

  while (x^.Next<> nil) and (x^.Next.Way.Cost < Way.Cost) do
    x:=x^.Next;

  New(y);
  y^.Way:=Way;
  y^.Next:=x^.Next;
  x^.Next:=y;
end;




procedure TForm1.FormCreate(Sender: TObject);
begin
  //SetCountElem(StrtoInt(seCountElem.Text));
end;

procedure TForm1.PaintTipArray(const x, y: integer; Direction: Real);
var
  xleft,yleft:integer;
  xright, yright:integer;
begin
  xleft:= x;
  yleft:= y;
  //Direction := (-1)*Direction;
  xright:= x;
  yright:= y;
  GetNewCord (xleft,yleft, Direction + DegreeArrow,LengthArrow);
  GetNewCord (xright,yright, Direction -  DegreeArrow,LengthArrow);

  with imgGraphView.Canvas do
  begin
    Pen.Width :=ArroyWidth;
    Pen.Color := ColorPenArrow;
    Brush.Color := ColorPenArrow;
    Polygon([
      Point(x,y),
      Point(xleft,yleft),
      Point(xright,yright)]);
  end;

end;

procedure TForm1.GetNewCord(var x, y: integer; const Direction,
  Length: real);
begin
  x:= x+ Round(cos(Direction)*Length);
  y:= y+ Round(sin(Direction)*Length);
end;

procedure TForm1.PaintArray(X1, Y1, X2, Y2: integer; const leftTip,
  RightTip: boolean);
Var
  Direction:Real;
  temp:integer;
begin
  if (X2=X1) and (Y2=Y1) then exit;
  if X1>X2 then
  begin
    temp := X2;
    X2:=X1;
    X1:=temp;

    temp:= Y2;
    Y2:=Y1;
    Y1:=temp;
  end;
    Direction := DegreeBetween(X1, Y1, X2, Y2);
  with imgGraphView.Canvas do
  begin
    Pen.Width := ArroyWidth;
    Pen.Color := ColorPenArrow;
    MoveTo(X1, Y1);
    LineTo(X2, Y2);
  end;

  if leftTip then PaintTipArray(X1, Y1,Direction);
  if rightTip then PaintTipArray(X2, Y2, Pi+Direction);
end;

procedure TForm1.PaintText(const X, Y: integer;const ColorText,ColorBrush: TColor;const Text: string);
begin
  with imgGraphView.Canvas do
  begin
    Font.Color := ColorText;
    Brush.Color := ColorBrush;
    TextOut(X,Y,Text);
  end;
end;

procedure TForm1.PaintConnection(X1, Y1, X2, Y2, LengthLeft,
  LengthRight: integer);
var
 leftTip, RightTip:boolean;
 Direction,ShiftDirection:real;
 temp :integer;
begin
  if X1>X2 then
  begin
    temp := X2;
    X2:=X1;
    X1:=temp;

    temp:= Y2;
    Y2:=Y1;
    Y1:=temp;

    temp:= LengthLeft;
    LengthLeft:=LengthRight;
    LengthRight:=temp;

  end;

  leftTip := not ((LengthLeft = 0) or (LengthLeft >=Infinity));
  RightTip := not ((LengthRight = 0) or (LengthRight >=Infinity));
  if not leftTip and not RightTip then exit;


  Direction := DegreeBetween(X1, Y1, X2, Y2);
  GetNewCord(X1, Y1,Direction,RadiusElem);
  GetNewCord(X2, Y2,Pi+Direction,RadiusElem);
  PaintArray(X1, Y1, X2, Y2,leftTip,RightTip);
  GetNewCord(X1, Y1,Direction,ShiftText);
  //GetNewCord(X1, Y1,Direction+pi/2,10);
  GetNewCord(X2, Y2,Pi+Direction,ShiftText);
  //GetNewCord(X2, Y2,Direction+pi/2,10);
  if leftTip then PaintText(X1, Y1,ColorTextArrow,ColorBrushArrow,IntToStr(LengthLeft));
  if rightTip then PaintText(X2, Y2,ColorTextArrow,ColorBrushArrow,IntToStr(LengthRight));
end;

function TForm1.DegreeBetween(X1, Y1, X2, Y2: real): real;
begin
  if X2-X1 = 0 then
    if Y2>Y1 then Result := pi/2
    else Result := -pi/2
  else
  Result:= ArcTan((Y2-Y1)/(X2-X1));
end;

procedure TForm1.PaintElem(const X1, Y1:integer; Text: string);
begin
  with imgGraphView.Canvas do
  begin
    Pen.Color:= ColorElemPen;
    Brush.Color := ColorElemBrush;
    Font.Color := ColorElemText;
    Ellipse(X1-RadiusElem,Y1-RadiusElem,X1+RadiusElem,Y1+RadiusElem);
    TextOut(X1-5, Y1-5, Text);
  end;
end;

procedure TForm1.ClearImage;
begin
  with imgGraphView do
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.Pen.Width := 2;
    Canvas.Rectangle(-2,-2,Width+2,Height+2);
  end;
end;

procedure TForm1.PaintGraph;
var
  CordElem:TwoDimenMatrric;
  CenterElem:byte;
  CountElem:byte;
  i,j:integer;
  DegreeBetween:Real;
  DegreeNow:Real;
  Xnow,YNow:integer;
begin
  ClearImage;
  CountElem := Length(AdjTab);
  if CountElem = 0 then exit;
  SetLength(CordElem,2,Length(AdjTab));
  CenterElem := GraphCenter;

  CordElem[0][CenterElem] := imgGraphView.Width shr 1;
  CordElem[1][CenterElem] := imgGraphView.Height shr 1;

  DegreeNow := pi/6;

  DegreeBetween:= 2*pi/Max((CountElem-1),1);

  for i:= 0 to CountElem-1 do
  begin
    if i <> CenterElem then
    begin
      Xnow:= CordElem[0][CenterElem];
      YNow:= CordElem[1][CenterElem];
      GetNewCord(Xnow,YNow,DegreeNow,DistanceFromCenter);
      DegreeNow := DegreeNow + DegreeBetween;
      YNow:=YNow+ShiftCenter;
      CordElem[0][i]:=Xnow;
      CordElem[1][i]:=YNow;
    end;
    PaintElem(CordElem[0][i],CordElem[1][i],IntToStr(i));
  end;

  for i:=Low(AdjTab) to High(AdjTab) do
    for j:=Low(AdjTab) to i-1 do
      PaintConnection(CordElem[0][i],CordElem[1][i],CordElem[0][j],CordElem[1][j],AdjTab[j,i],AdjTab[i,j]);
end;

function TForm1.GraphCenter (FloidRes:TwoDimenMatrric):Byte;
var
  MaxWay : array of Integer;
  i,j : Integer;
begin
  SetLength(MaxWay, High(AdjTab)+1);
  for i := 0 to High(AdjTab)  do
  begin
    MaxWay[i] := FloidRes[0, i];
    for j := 0 to High(AdjTab) do
      if MaxWay[i] < FloidRes[j, i] then
        MaxWay[i] := FloidRes[j, i];
  end;

  Result:=0;
  for i := 0 to High(AdjTab) do
    if MaxWay[i] < MaxWay[Result] then
      Result:=i;
end;

function TForm1.FloidAlgorithm : TwoDimenMatrric;
var
  i, j, k : Integer;
begin
  SetLength(Result,High(AdjTab) + 1, High(AdjTab) + 1);
  for i := 0 to High(AdjTab) do
    for j := 0 to High(AdjTab) do
      Result[i,j] := AdjTab[i, j];

  for k := 0 to High(AdjTab) do
    for i := 0 to High(AdjTab) do
      for j := 0 to High(AdjTab) do
        if Result[i, k] + Result[k, j] < Result[i, j] then
          Result[i, j]:= Result[i, k] + Result[k, j];
end;

function TForm1.DeykstraAlgorithm(start : Byte; out Way : OneDimenMatrric) : OneDimenMatrric;
var
  Used : UsedWayMn;
  i, j : byte;
  min : integer;
begin
  Used := [];
  SetLength(Result,High(AdjTab) + 1);
  SetLength(Way, High(AdjTab) + 1);
  for i := 0 to High(Result) do
  begin
    Result[i] := AdjTab[start, i];
    Way[i] := start;
  end;

  for j := 0 to High(AdjTab) do
  begin
    Used := Used + [start];

    for i := 0 to High(Result) do
      if Not (i in Used) then
        if Result[i] > Result[start] + AdjTab[start, i] then
        begin
          Result[i] := Result[start] + AdjTab[start, i];
          Way[i] := start;
        end;

    min := MaxInt;
    for i := 0 to High(Result) do
      if Not (i in Used) And (Result[i] < min) then
      begin
        min := Result[i];
        start := i;
      end;
  end;
end;

function TForm1.GraphCenter: Byte;
begin
 Result:= GraphCenter(FloidAlgorithm);
end;

function TForm1.TranslateAdjTab: boolean;
var
  i,j,TempInt:integer;
  f: textfile;
begin
  if openDialog1.Execute then
    begin
    assignFile(f, openDialog1.FileName);
    reset(f);
    readln(f, CountElem);

    SetLength(AdjTab,CountElem,CountElem);
    Result:=true;
    for i := 0 to CountElem-1 do
      for j := 0 to CountElem-1 do
      try
        read(f, TempInt);
        AdjTab[i, j] := TempInt;
        if AdjTab[i, j] = 0 then  AdjTab[i,j] := Infinity;
      except
        MessageBox(handle,PWideChar('?????? ? ['+IntToStr(i)+','+IntToStr(j)+']'),
        PWideChar('??????!'),MB_OK or MB_ICONERROR);
        Result := false;
        exit;
      end;
  end;
  closefile(f);
end;

procedure TForm1.btnGraphPaintClick(Sender: TObject);
begin
 if not TranslateAdjTab then exit;
 PaintGraph;
 lbCenterGraph.Caption := IntToStr(GraphCenter);
 btnDoCalculation.Enabled := true;
end;

procedure TForm1.strgrAdjTabKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 btnDoCalculation.Enabled := false;
end;

procedure TForm1.DoCalculation;
var
  Ways,x:TLWayList;
  ShortWay,Way:OneDimenMatrric;
  WayName:string;
  i:integer;
begin
  Ways := FindWay;
  x := Ways^.Next;
  mmAllWay.Clear;
  while x <> nil do
  begin
    mmAllWay.Lines.Add( IntToStr(x^.Way.Cost) + ' -> ' + x^.Way.Name );
    x := x^.Next;
  end;

  x := Ways;
  while x^.Next <> nil do
    x := x^.Next;
  if x^.Way.Name <> '' then
    lbMaxWay.Caption :=  x^.Way.Name + '{' + IntToStr(x^.Way.Cost) + '}'
  else
    lbMaxWay.Caption := '(infinity)';

  ShortWay := DeykstraAlgorithm(strtoint(seStartPoint.Text),Way);
  if ShortWay[strtoint(seFinishPoint.Text)] >= Infinity then
  begin
    lbMinWay.Caption:= '(infinity)';

  end
  else
  begin
    WayName := seFinishPoint.Text;
    i := Way[strtoint(seFinishPoint.Text)];
    lbMinWay.Caption := '';
    while i <> strtoint(seStartPoint.Text) do
    begin
      WayName := WayName + IntToStr(i);
      i := Way[i];
    end;
    WayName := WayName + seStartPoint.Text;

    for i:= Length(WayName) downto 1 do
      lbMinWay.Caption := lbMinWay.Caption + WayName[i] + ' ';
    lbMinWay.Caption := lbMinWay.Caption +'{' +  IntToStr(ShortWay[strtoint(seFinishPoint.Text)]) + '}' ;
  end;
end;

function TForm1.FindWay: TLWayList;
var
  Src, Dest : Integer;
  NullWay : TWay;
  Ways : TLWayList;

  procedure FindRoute(V: Integer; Way:TWay);
  var
    i: Integer;
    NewWay : TWay;
  begin
    if V = Dest then
      AddToSortedList(Way,Ways)
    else
    for i := 0 to High(AdjTab[V]) do
      if (AdjTab[V, i] <> Infinity) and Not( i in Way.Used) then
      begin
        NewWay.Used := Way.Used + [i];
        NewWay.Name := Way.Name + IntToStr(i) + ' ';
        NewWay.Cost := Way.Cost + AdjTab[V,i];
        FindRoute(i, NewWay);
      end;
  end;

begin
  Ways := NewList;
  Src := strtoint(seStartPoint.Text);
  Dest := strtoint(seFinishPoint.Text);
  with NullWay do
  begin
    Name := IntToStr(Src) + ' ';
    Cost := 0;
    Used := [Src];
  end;
  FindRoute(Src,NullWay);
  Result := Ways;
end;

procedure TForm1.btnDoCalculationClick(Sender: TObject);
begin
  DoCalculation;
end;

end.
