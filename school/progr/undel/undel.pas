Uses DOS,F_DISK;

Const DirCount  : LongInt = 0; { ������⢮ ��⠫���� }
      FileCount : LongInt = 0; { ������⢮ 䠩��� }
Var StartDir,Symbol:String;

Procedure UndelDir( DirName:String ); { ����⠭������� ��⠫��� }
  Var
    Dir:Array [1..16] of Dir_Type; { ���� �� 1 ᥪ�� ��⠫��� }
    Disk : Byte;                   { ����� ��᪠ }
    Dirs : Word;                   { ����� ᥪ�� }
    DirSize: Word;                 { ������ ��⠫��� }
    J   : Integer;                 { ����� ����� ��⠫��� }
    K,I:Integer; DI:TDisk; SN,SE,SNE:String;
    Clus:Word; { ����� ������ }
  Begin { UndelDir }
   { �᪠�� ��⠫�� }
    GetDirSector(DirName,Disk,Dirs,DirSize);
    If Dirs = 0 then Exit; { Dirs=0 - �訡�� � ������� }
    GetDiskInfo(Disk,DI);         { ����砥� ����� ������ }
    ReadSector(Disk,Dirs,1,Dir);  { ��⠥� ���� ᥪ�� }
    K := 0;               { ������⢮ ��ᬮ�७��� ����⮢ }
    J := 1;               { ����騩 ����� ��⠫��� }
   { ���� ���᪠ }
    Repeat
     { �ய�᪠�� ��୥��� � ��� ��⠫�� (H�祣� �� ��稭����� �� '.') }
      While Dir[J].NameExt[1] = '.' do Inc(J);
      If Dir[J].Name[1]=#0 then Exit; { �����㦥� ����� ᯨ᪠ 䠩��� }
      If (Dir[j].FAttr and Directory) = 0 then { ����⨪� }
        Inc(FileCount) Else Inc(DirCount);
      SN:=Dir[J].Name;
      While SN[Length(SN)]=' ' do SN:=Copy(SN,1,Length(SN)-1);
      SE:=Dir[J].Ext;
      While SE[Length(SE)]=' ' do SE:=Copy(SE,1,Length(SE)-1);
      If SE = '' then SNE:=SN Else SNE:=SN+'.'+SE;
      Writeln('* ',DirName,'\',Dir[J].Name);
  {   If Dir[j].NameExt[1] = #229 then
        Begin
          Dir[j].NameExt[1] := Symbol[1];
          Writeln('- Undeleted ! ',Dir[j].NameExt);
          WriteSector(Disk,Dirs,1,Dir);
        End;}
      If (Dir[j].FAttr And Directory) <> 0 then UndelDir(DirName+'\'+SNE);
      Inc(J);
      If J = 17 then
        Begin
          Inc(K,16);
          if K >= DirSize then Exit; { ��諨 �� ���� ��⠫��� }
          J := 1;         { �த������ � 1-�� ����� ᫥���饣� ᥪ�� }
          If (K div 16) mod DI.ClusSize=0 then
            If Succ(Dirs) < DI.DataLock then
              Inc(Dirs)       { ��୥��� ��⠫�� }
            Else
              Begin   { ����� ������ }
                Clus := GetFATItem(Disk,GetCluster(Disk,Dirs)); { ���� ������ }
                Dirs := GetSector(Disk,Clus) { ���� ᥪ�� }
              End
          Else Inc(Dirs); { ��।��� ᥪ�� - � ������ }
          ReadSector(Disk,Dirs,1,Dir)
        End;
    Until Dir[J].Name[1]=#0;
  End; { UndelDir }

Begin
  Writeln('- �ணࠬ�� ��� ����⠭������� ��ॢ� ��⠫���� -');
  Writeln('���쪮 ��� FAT12,FAT16 ! �� �����প�� ��������: Denis@ipo.spb.ru');
{  If ParamCount = 2 then
    Begin}
{      StartDir:=ParamStr(1);
      Writeln(' * ����⠭��������� ��⠫��: ',StartDir);
      Symbol:=ParamStr(2);
      Writeln(' * H�砫�� ���� ᨬ���: ',Symbol[1]);}
      StartDir:='D:\USERS\DENIS';
      Writeln('��⮪�� ����⠭�������: ');
      Symbol:='#';
      UndelDir(StartDir);
      Writeln('����⠭������: ������ ',FileCount,' ��⠫���� ',DirCount);
{    End
  Else
    Begin
      Writeln('�������� ! H���୮� ������⢮ ��ࠬ��஢.');
      Writeln('��� ����᪠ �ᯮ����:');
      Writeln('  Undel <��� ����⠭����������� ��⠫���> <H�砫�� ���� ᨬ���>');
      Writeln('H��ਬ��: Undel D:\USERS #   - ��� ����⠭������� ��⠫��� USERS');
      Writeln('�� �⮬ �ணࠬ�� ����⠭���� ᮤ�ন��� ��⠫��� USERS �� ��᪥ D.');
      Writeln('�� 䠩�� � ��⠫��� ���� ����⠭������ ��� �������');
      Writeln('��稭��騬��� �� #. �᫨ ��������� ��� 䠩�� (��⠫���) ����� ������');
      Writeln('���� �⫨����� ⮫쪮 ��ࢮ� �㪢��, �㤥� ��࠭ ᫥���騩 ᨬ���');
      Writeln('⠡���� ASCII (ᨬ��� $, ��⥬ %,...)');
    End;}
End.End.