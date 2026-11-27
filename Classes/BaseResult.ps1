class BaseResult {
    [datetime]$Timestamp

    BaseResult() {
        $this.Timestamp = Get-Date
    }

    hidden [hashtable] GetBaseHashtable() {
        return [ordered]@{
            Timestamp = $this.Timestamp.ToString('o')
        }
    }

    [hashtable] ToHashtable() {
        throw 'ToHashtable() must be implemented by derived classes.'
    }

    [string] ToJson() {
        return (
            $this.ToHashtable() |
            ConvertTo-Json -Depth 20 -Compress
        )
    }

    [string] ToString() {
        return $this.ToJson()
    }
} #class BaseResult