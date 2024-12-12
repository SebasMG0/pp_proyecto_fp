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
                TempDef:= {Pars R}  
                {Show @TempDef}
                @TempDef
            end
        end
    end
end

fun {Pars Pred}
    case Pred of H|T then
        if H == 40 then  % '('
            {Pars T}
        elseif H == 41 then  % ')'
            if {Int.is @TempDef} then TempVar := [@TempDef]
            else TempVar := {Record.toList @TempDef} end
            TempDef := nil

            if @TempTree == nil then
                TempTree := @TempVar
            else
                TempTree := tree(l:@TempTree r:@TempVar)
            end
            @TempTree

        elseif {List.member H [42 43 45 47]} then  % '*', '+', '-', '/'
            if {Int.is @TempDef} then TempVar := [@TempDef]
            else TempVar := {Record.toList @TempDef} end
            TempDef := nil

            if @TempTree == nil then
                TempTree := tree(l:H r:@TempVar)
            else
                TempTree := tree(l:@TempTree r:@TempVar)
            end

            {Pars T}
        else
            if @TempDef == nil then TempDef := H
            else TempDef := @TempDef|H end

            {Pars T}
        end
    else
        if {Int.is @TempDef} then TempVar := [@TempDef]
        else TempVar := {Record.toList @TempDef} end
        TempDef := nil

        if @TempTree == nil then
            TempTree := TempVar
        else
            TempTree := tree(l:@TempTree r:TempVar)
        end
        @TempTree
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
fun square x y = (x+y-z) * (x-y) * ((x+y+z)*2)
square 33
" 
    
C = {String.tokens L & }
{ProcString C}
