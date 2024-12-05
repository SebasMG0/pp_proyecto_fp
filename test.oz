declare

fun {Test Vars}
    case Vars of H|T then
        if H == "=" then nil
        else H|{Test T} end
    end
end




L= "x y = x*x"
C = {String.tokens L & }

K= {Test C}
{Browse K}