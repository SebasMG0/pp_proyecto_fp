declare

proc {Test Vars}
    case Vars of "=" then
        {Browse 'h'}
    else
        {Browse 'else'}
    end
end


L= "x y z ="

C = {String.tokens L & }
{Browse C}
{Test C}
