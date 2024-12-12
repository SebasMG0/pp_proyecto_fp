declare

LocalPred = {NewCell nil}
Funcs = {NewCell nil}
Vars = {NewDictionary}
TempVar= {NewDictionary}

proc {ProcString Pred}
    case Pred of [10 102 117 110]|T then
        if @Funcs == nil then
            Funcs:= {AddVars T}| {GetSimDef @LocalPred}
        else
            Funcs:= @Funcs|{AddVars T} | {GetSimDef @LocalPred}
        end
        {Browse 'Función definida con sus variables y árbol:'}
        {Browse @Funcs}
    else
        {RedExec Pred}
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

fun {Oper Op1 Op2 Sym}
    if Sym == 42 then
        Op1 * Op2
    elseif Sym == 43 then
        Op1 + Op2
    elseif Sym == 45 then
        Op1 - Op2 
    elseif Sym == 47 then
        Op1 / Op2
    end
end

fun {GetFunVars}
    case {List.nth {Record.toList @Funcs} 1} of nil then nil
    [] H|T then T end
end

fun {GetFunTree}
    {List.nth {Record.toList @Funcs} 2}
end

fun {GetFunName}
    {List.nth {List.nth {Record.toList @Funcs} 1} 1}
end

proc {RedExec Pred}
    case Pred of H|T then
        if H == {GetFunName} then
            LocalPred:= {DefParams T {GetFunVars} 1 Vars}
            {Browse 'Variables definidas'}
            {Browse {Dictionary.entries Vars}}     
        end
    end
end

% proc {RedExec Pred}
%     case Pred of nil then nil
%     [] H|T then
%         if H == {GetFunName} then
%             {DefParams T {GetFunVars} 1 Vars}
            
%         end
%     end
% end

% fun {DefParams Pred LVars}
%     i in 1..{List.length LVars}
%         if {List.nth Pred i} == {GetFunName} then
%             {DefParams }
%         else end

% end

fun {DefParams Pred LVars I D}
    case Pred of nil then nil
    [] H|T then
        if H == {GetFunName} then
            {Dictionary.put D {List.nth LVars I} {DefParams T LVars 1 TempVar}}
        else
            {Dictionary.put D {List.nth {List.nth LVars I} 1} H}
            {DefParams T LVars I+1 Vars}
        end
    end
end

proc {SplitInput Pred}
    case {String.tokens Pred &
    } of N|D|E|F then
        {ProcString {String.tokens D & }}
        % {Browse {String.tokens E & }}

        case E of H|T then 
            {ProcString {String.tokens T & }}
        end
    end
end


ExpA = "
fun operation x y z = (x*(x+y)) - (z/y)
operation 1 2 4
" 

ExpB= "
fun square x = x * x
square square 3
"

ExpC="
fun twice x = x + x
twice 5
"

% {SplitInput ExpA}
% {SplitInput ExpB}
{SplitInput ExpC}

% {ProcString {SplitInput ExpA}}
% {ProcString C}


%% /////////////////////////////////////////////////////////////////////////////
%%
%% Es necesario que todo el código a probar esté dentro de las comillas pero
%% que no estén junto a ellas. Es decir, comillas dobles, en la siguiente línea empieza
%% el código y las comillas finales en una nueva línea.  
%%
%% - Las cosas entre paréntesis no utilizan espacios, si está fuera sí
%% - En cada paréntesis solo hay una operación (x+y) o (x+(y+z))
%% - Por simplicidad (tiempo) se ejecuta de a una sola expresión
%% /////////////////////////////////////////////////////////////////////////////
