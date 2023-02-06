## Copyright (C) 2023 Nicolas
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} findMinMax (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Nicolas <Nicolas@DESKTOP-3V99RAT>
## Created: 2023-02-02

function [retval,numberRow] = findMinMax (data)
retval=zeros(rows(data),1);
numberRow=0;
for x=1:1:rows(data)
  y=max(data(x,1:1:columns(data)))-min(data(x,1:1:columns(data)));
  if y>retval(x,1)
    retval(x,1)=y;
    numberRow=x;
  endif
endfor
endfunction
