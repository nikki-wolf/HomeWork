Attribute VB_Name = "Module2"
Sub Stock()

Dim Yrchg, Prcchg As Long


'constant labels
    
    row_fix = 2
    col_Tic = 1
    col_Open = 3
    col_close = 6
    col_Vol = 7
    col_PrtTic = 9
    col_PrtYrChg = 10
    col_PrtPerChg = 11
    col_PrtTotStVol = 12
    col_PrtDescrip = 15
    col_PrtMaxInc = 15
    col_PrtMaxDec = 16
    col_MaxTotVol = 17
    
For Each ws In Worksheets
    MsgBox (ws.Name)
    'Finding the no. of rows containing dataset
    Max_row = ws.Cells(Rows.Count, 1).End(xlUp).Row - 1
          
 
    'Headers
    ws.Cells(1, col_PrtTic).Value = "Ticker"
    ws.Cells(1, col_PrtYrChg).Value = "Yearly Change"
    ws.Cells(1, col_PrtPerChg).Value = "Percent Change"
    ws.Cells(1, col_PrtTotStVol).Value = "Total Stock Volume"
    

    'initialization
    curr_tic = 2
    TotStVol = 0
    ws.Cells(curr_tic, col_PrtTic).Value = ws.Cells(row_fix, col_Tic).Value
    Open_tic = ws.Cells(row_fix, col_Open).Value
    
    For i = 0 To Max_row
        'getting to a different stock
        If (ws.Cells(i + row_fix + 1, col_Tic).Value <> ws.Cells(i + row_fix, col_Tic).Value) Then
            ws.Cells(curr_tic, col_PrtTotStVol).Value = TotStVol
            ws.Cells(curr_tic, col_PrtYrChg).Value = Yrchg
            ws.Cells(curr_tic, col_PrtPerChg).Value = Perchg
            'format cells
            If Yrchg > 0 Then
                ws.Cells(curr_tic, col_PrtYrChg).Interior.Color = RGB(0, 255, 0)
            Else
                ws.Cells(curr_tic, col_PrtYrChg).Interior.Color = RGB(255, 0, 0)
            End If
            ws.Cells(curr_tic, col_PrtPerChg).NumberFormat = "0.00%"
            
            ' assign new total volume and opening price
            TotStVol = ws.Cells(i + row_fix + 1, col_Vol).Value
            Open_tic = ws.Cells(i + row_fix + 1, col_Open).Value
            
            ' assign next tic and printing
            curr_tic = curr_tic + 1
            ws.Cells(curr_tic, col_PrtTic).Value = _
                               Cells(i + row_fix + 1, col_Tic).Value
        Else
            TotStVol = TotStVol + ws.Cells(i + row_fix + 1, col_Vol).Value
            Close_tic = ws.Cells(i + row_fix + 1, col_close).Value
            Yrchg = Close_tic - Open_tic
            If Open_tic <> 0 Then
                Perchg = Yrchg / Open_tic
            Else
                Perchg = 1
            End If
    
        End If
        
    Next i
        
    'finding the greatest and print
    Dim MaxChg, MinChg, MaxTot As Double
    Dim TicMaxChg, TicMinChg, TicMaxTot As String
    
    'Copy tickers to make them the last column in Vloopk
    ws.Columns(col_PrtTic).Copy Destination:=ws.Columns(col_PrtTotStVol + 1)
    
                               
    MaxChg = Application.WorksheetFunction.Max(Range(ws.Cells(2, col_PrtPerChg), _
             ws.Cells(curr_tic, col_PrtPerChg)))
    MinChg = Application.WorksheetFunction.Min(Range(ws.Cells(2, col_PrtPerChg), _
             ws.Cells(curr_tic, col_PrtPerChg)))
    MaxTot = Application.WorksheetFunction.Max(Range(ws.Cells(2, col_PrtTotStVol), _
             ws.Cells(curr_tic, col_PrtTotStVol)))
              
    TicMaxChg = WorksheetFunction.VLookup(MaxChg, Range(ws.Cells(2, col_PrtPerChg), _
             ws.Cells(curr_tic, col_PrtTotStVol + 1)), 3, False)
             
    TicMinChg = WorksheetFunction.VLookup(MinChg, Range(ws.Cells(2, col_PrtPerChg), _
             ws.Cells(curr_tic, col_PrtTotStVol + 1)), 3, False)
             
    TicMaxTot = WorksheetFunction.VLookup(MaxTot, Range(ws.Cells(2, col_PrtTotStVol), _
             ws.Cells(curr_tic, col_PrtTotStVol + 1)), 2, False)
             
   'Delete the redundant column of tickers that was used in the Vlookup
    ws.Columns(col_PrtTotStVol + 1).EntireColumn.Delete
    
    'Print headers
    ws.Cells(2, col_PrtDescrip).Value = "Greatest % Increase"
    ws.Cells(3, col_PrtDescrip).Value = "Greatest % Decrease"
    ws.Cells(4, col_PrtDescrip).Value = "Greatest Total Volume"
    ws.Cells(1, col_PrtDescrip + 1).Value = "Ticker"
    ws.Cells(1, col_PrtDescrip + 2).Value = "Value"
    
    'Print extreme values
    ws.Cells(row_fix, col_PrtDescrip + 1).Value = TicMaxChg
    ws.Cells(row_fix + 1, col_PrtDescrip + 1).Value = TicMinChg
    ws.Cells(row_fix + 2, col_PrtDescrip + 1).Value = TicMaxTot
    
    ws.Cells(row_fix, col_PrtDescrip + 2).Value = MaxChg
    ws.Cells(row_fix + 1, col_PrtDescrip + 2).Value = MinChg
    ws.Cells(row_fix + 2, col_PrtDescrip + 2).Value = MaxTot
    
    'format cells
    ws.Cells(row_fix, col_PrtDescrip + 2).NumberFormat = "0.00%"
    ws.Cells(row_fix + 1, col_PrtDescrip + 2).NumberFormat = "0.00%"
    
    ' Autofit
    ws.Columns("I:Q").AutoFit
Next ws

End Sub
