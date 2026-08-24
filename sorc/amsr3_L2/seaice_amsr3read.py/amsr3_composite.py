#!/usr/bin/env python3
'''
Loop over input arg list (JRR-IceConcentration*)
 and composite the concentration and temperatures on to global_12th grids
 write out in netcdf
fname are in this convention: 
  "20220828/JRR-IceConcentration_v2r3_j01_s202208281036198_e202208281037426_c202208281059540.nc"
Robert.Grumbine
25 November 2025
'''

import sys
import datetime
from math import sqrt

import numpy as np
from numpy import ma
import netCDF4 as nc

from latpt import *
from grid import *

#---------------------------------------------------------------------------
#debug: print("number of input files ", len(sys.argv[]), flush=True)

#For output grid:
target_grid = global_5min()
csumx  = np.zeros((target_grid.ny,target_grid.nx))
csumx2 = np.zeros((target_grid.ny,target_grid.nx))
gcount = np.zeros((target_grid.ny,target_grid.nx),dtype=int)
#debug: 
print("target grid dimensions",target_grid.ny,target_grid.nx, file=sys.stderr)

nfiles = 0
totnp = 0

for fname in sys.argv[1:]:
  nfiles += 1
  #debug: print(nfiles, fname,flush=True)
  #debug: continue

  try:
    amsr3 = nc.Dataset(fname, 'r')
  except:
    print("Could not open fname: ",fname,flush=True, file=sys.stderr)
    continue

  #debug: print("dimensions ",len(amsr3.dimensions['Columns']), len(amsr3.dimensions['Rows']) )

  conc = amsr3.variables['NASA_Team_2_Ice_Concentration'][:,:]
  #debug: print(nfiles,"conc ",conc.max(), conc.min(),flush=True, file=sys.stderr )
  indices = conc.nonzero()
  #debug: print('length of indices:', f"{len(indices[0]):d}" , flush=True)
  #debug: continue
  npts = len(indices[0])
  if (npts == 0):
      continue
  totnp += len(indices[0])

  #Geography:
  lats = amsr3.variables['Latitude'][:,:]
  lons = amsr3.variables['Longitude'][:,:]
  flag = amsr3.variables['Flags'][:,:]

  #Start Working:
  for k in range(0,len(indices[0])):
      i = indices[1][k]
      j = indices[0][k]
      if (flag[j,i] != 0):
          #debug: print("nonzero flag = ",flag[j,i])
          continue
      #verbose: print(lons[j,i], lats[j,i], conc[j,i], " pt")
      # for gridding
      iloc = target_grid.inv_locate(lats[j,i],lons[j,i])
      ti = int(iloc[0]+0.5)
      if (ti == target_grid.nx):
        ti = 0
      tj = int(iloc[1]+0.5)
      gcount[tj,ti] += 1
      c =  conc[j,i]
      csumx[tj,ti]  += c
      csumx2[tj,ti] += c*c

  #debug: if (nfiles >= 100): break

print("total number of files, ice conc observations: ",nfiles, totnp, file=sys.stderr)

z = latpt()
cellcount = 0
mask = ma.masked_array(gcount > 0)
indices = mask.nonzero()
#set grids to weather
#create lat-lon grids for nc output
for k in range(0,len(indices[0])):
    i = indices[1][k]
    j = indices[0][k]
    csumx[j,i] /= gcount[j,i]
    csumx2[j,i] = sqrt(max(0., csumx2[j,i]/gcount[j,i] - csumx[j,i]*csumx[j,i]) )
    target_grid.locate(i,j,z)

    print(i,j,z.lat, z.lon, csumx[j,i], csumx2[j,i], gcount[j,i], flush=True, file=sys.stdout)
    cellcount += 1

print("gcount, avg: ",gcount.max(), gcount.min(), file=sys.stderr  )
print("cellcount = ",cellcount,file=sys.stderr)
