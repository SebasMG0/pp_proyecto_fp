declare

LocalPred = {NewCell nil}
Funcs = {NewCell nil}

TempDef = {NewCell nil}
TempVar = {NewCell nil}

TempTree= {NewCell nil}

proc {ProcString Pred}
    case Pred of [13 10 102 117 110]|T then
        Funcs:= @Funcs|[{AddVars T}| {FuncDef @LocalPred}]
    end
end

fun {AddVars Vars}
    case Vars of H|T then
        if H == "=" then LocalPred:=T nil
        else H|{AddVars T}
        end
    end
end

fun {FuncDef Pred}
    case Pred of H|T then
        case H of F|R then
            if F == 40 then
                {Browse 'expr'}
                TempDef:= {GetPar R nil nil}  
                {Show @Browse}
                @TempDef
            end
        end
    end
end

fun {GetPar Pred Var Op} 
    case Pred of H|T then
        if H == 40 then
            if Op == null then 
                {GetPar T nil nil}
            else
                tree(l:tree(l:Op r:{GetPar T nil nil}) r:Var)
            end

        elseif H == 41 then
            LocalPred:= T
            tree(l:Op r:Var)
        
        elseif {List.member H [42 43 45 47]} then
            {GetPar T Var H}
        
        elseif H == 13 then
            LocalPred:= T
            tree(l:Op r:Var)

        else
            if Var == nil then
                {GetPar T H nil}
            else
                {GetPar T tree(l:tree(l:Op r:H) r:Var) nil}
            end
        end
    end
end

%% /////////////////////////////////////////////////////////////////////////////
%%
%% Es necesario que todo el código a probar esté dentro de las comillas pero
%% que no estén junto a ellas. Es decir, comillas dobles, en la siguiente línea empieza
%% el código y las comillas finales en una nueva línea.  
%%
%% - Las cosas entre paréntesis no utilizan espacios, si está fuera sí: ((x+y+z)*2)
%%   ó (x+y+z) * 2 son correctos.
%% - Los paréntesis se usan para
%% /////////////////////////////////////////////////////////////////////////////

L = "
fun square x y = (x+y-z)
" 
    
C = {String.tokens L & }
{Show C}
