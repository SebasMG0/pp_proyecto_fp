declare
Vars= {NewCell nil}
Funcs= {NewCell nil}



proc {ProcessString S}
    case S of [13 10 102 117 110]|T then 
        Funcs:= @Funcs|[{AddVars T}]
        {Browse @Funcs}

    end
end

fun {AddFun }
    0
end

fun {AddVars Vars}
    case Vars of H|T then
        if H == "=" then nil 
        else H|{AddVars T}
        end
    end
end


local
L = "
fun square x y z = x*x
square square 3
" 
    
C K in

    C = {String.tokens L & }
    {Browse C}
    {ProcessString C}
    %K= {ProcessString C}
    %{Browse K}

end
