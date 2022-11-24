function Get-Tree 
{
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)] # Parametr obowiązkowy to ścieżka
        [string] $Path, # Ustawianie typu parametru na string
        [Parameter(Mandatory = $true, Position = 1)] # parametr obowiązkowy przyjmujący rozszerzenie do znalezienia
        [string] $Extension # Ustawianie typu parametru na string
    )
    $FolderList = Get-ChildItem -Path $Path -Recurse -File -Include $Extension # Pobranie wszystkich plikow z danym rozszerzniem
    $FolderList = $FolderList | Select-Object -ExpandProperty FullName -Property LastWriteTime # Znalezienie tylko sciezek z czasem modyfikacji
    if ($FolderList) # Sprawdzenie czy powstaly foldery
    {
        foreach ($Folder in $FolderList) 
        {
            $SplitedArray = $Folder.Replace($Path, "").Split('\') # Zmiana ścieżki z absolutnej na relatywną oraz podzielenie na foldery
            $LastElem = $SplitedArray[-1] # Ostatni folder ścieżki
            $FirstElem = $SplitedArray[0] # Pierwszy folder ścieżki
            $StrToAdd = '' # Ciąg znaków dodawany do nazwy każdego folderu w celu symulacji drzewa folderów
            foreach ($Split in $SplitedArray) 
             {
                if ($Split -eq $FirstElem)
                {
                    $StrToAdd += '' # Przy pierwszym elemencie nie chcemy dodawać znaku |
                }
                elseif (!($Split -eq $FirstElem)) 
                {
                    $StrToAdd += '   |' # Przy kazdym elemencie oprocz pierwszego dodajemu odstep i | w celu symulacji drzewa 
                }
                Write-Output ($StrToAdd + $Split) # Wypisanie aktualnego statnu
                if ($Split -eq $LastElem) 
                {
                    $Time_mod = $Folder | Select-Object -ExpandProperty LastWriteTime # Znalezienie czasu ostatniej edycji
                    $Size = (Get-Item -Path $Folder).Length/1KB # Znalezienie rozmiaru pliku 
                    Write-Output "Data modyfikacji: $Time_mod" # Wypisanie czasu ostatniej edycji
                    Write-Output "Rozmiar: $Size KB" # Wypisanie rozmiaru pliku 
                }
            }
        }
    }
}
Get-Tree -Path D:\testy -Extension "*docx" # Uruchomienie funckji 