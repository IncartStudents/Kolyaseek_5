
#
function qrstable2dataframe(t)
    select = Tables.columns(t).timeQ .> 0
    t_ = t[select]

    ts = timestamps(t)
    event_pos = map(x->(first(x) + last(x)) ÷ 2, ts)

    type = mapsym_anz2physionet(t_.form_id)

    event_time = map(event_pos) do pos
        Dates.format(DateTime(t.tg[pos]), "H:MM:SS.sss") #Time("0:00:10.038", dateformat"H:MM:SS.sss")
    end
    comment = ["" for x in type] # пустые комменты

    out = DataFrame([event_pos, type, event_time, comment], [:event_pos, :type, :event_time, :comment])

    return out
end

function qrstable2csv(infile, outfile)
    t = readcols(infile)
    out = qrstable2dataframe(t)
    CSV.write(outfile, out, delim = ';')
end
