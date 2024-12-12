declare

LocalPred = {NewCell nil}
Funcs = {NewCell nil}

proc {ProcString Pred}
    case Pred of [10 102 117 110]|T then
        Funcs:= @Funcs|{AddVars T}| {GetSimDef @LocalPred}
        {Browse 'Función definida con sus variables y árbol:'}
        {Browse @Funcs}
    end
end

fun {GetSimDef Pred}
    case Pred of Op1|Sym|Op2 then
        tree(l:{CleanOp Op1} c: {CleanOp Sym} r:{CleanOp {List.nth Op2 1}})
    else
        nil
    end
end

fun {CleanOp Pred}
    if {List.length Pred} == 1 then
        Pred
    else 
        {GetPar Pred}
    end
end

fun {GetPar Pred}
    case Pred of nil then nil
    [] H|T then
        if H == 40 then 
            {GetPar T}

        elseif H == 41 then
            {GetPar T}

        elseif {List.member H [42 43 45 47]} then
            H

        else
            case T of F|R then
                if F == 41 then
                    H
                else
                    tree(l:H c:F r: {GetPar R})
                end
            end
        end
    end
end

fun {AddVars Vars}
    case Vars of H|T then
        if H == "=" then LocalPred:=T nil
        else H|{AddVars T}
        end
    end
end

proc {SplitInput Pred}
    case {String.tokens Pred &
    } of N|D|E|F then
        {ProcString {String.tokens D & }}
        {Browse {String.tokens E & }}
        % {ProcString {String.tokens E & }}
    end
end


% fun {SplitInput Pred}
%     {String.tokens {List.nth {String.tokens Pred &
%     } 2} & }
% end


ExpA = "
fun operation x y z = (x*(x+y)) + (z/y)
operation 3 4 5
" 


{SplitInput ExpA}
% {ProcString {SplitInput ExpA}}
% {ProcString C}