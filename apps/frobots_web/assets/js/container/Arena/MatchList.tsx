import React, { FC } from 'react';
import type { ChangeEvent, MouseEvent } from 'react';
import PropTypes from 'prop-types';
import {
  Box,
  Button,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TablePagination,
  TableRow,
  Typography,
} from '@mui/material';

interface MatchListTableProps {
  matchs: any[];
  matchsCount: number;
  onPageChange: (event: MouseEvent<HTMLButtonElement> | null, newPage: number) => void;
  onRowsPerPageChange?: (event: ChangeEvent<HTMLInputElement>) => void;
  page: number;
  rowsPerPage: number;
}

const getStatusName = (status: string) => {
  const statusColors = {
    live: '#37A6E4',
    upcoming: '#FFD600',
    completed: '#5BE584',
    cancelled: '#FF5630'
  };

  return (
    <Typography color={statusColors[status] || 'gray'} sx={{ textTransform: 'capitalize' }}>
      {status}
    </Typography>
  );
};

export const MatchList: FC<MatchListTableProps> = (props) => {
  const {
    matchs,
    matchsCount,
    onPageChange,
    onRowsPerPageChange,
    page,
    rowsPerPage,
    ...other
  } = props;

  return (
    <Box
      sx={{ position: 'relative' }}
      {...other}
    >
      <TableContainer sx={{ maxHeight: 320, minHeight: 320, backgroundColor: '#212B36', boxShadow: 'none' }}>
        <Table sx={{ minWidth: 500 }} stickyHeader={true}>
          <TableHead sx={{ color: '#fff' }}>
            <TableRow>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Match ID
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Match Name
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Host
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Status
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Time
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Actions
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody sx={{ color: '#fff' }}>
            {matchs?.length === 0 && (
              <TableRow>
                <TableCell>
                  No Data Found
                </TableCell>
              </TableRow>
            )}

            {matchs.map((match) => {

              return (
                <TableRow
                  hover
                  key={match.matchId}
                >
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack
                      alignItems="center"
                      direction="row"
                      spacing={1}
                    >
                      {match.matchId}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack
                      alignItems="center"
                      direction="row"
                      spacing={1}
                    >
                      {match.name}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {match.host}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {getStatusName(match.status)}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {match.time}
                  </TableCell>
                  <TableCell sx={{ color: '#fff', display: 'flex', justifyContent: 'space-around' }}>
                    {match.status !== 'completed'
                      ? (
                        <>
                          <Button
                            disabled={match.status === 'cancelled'}
                            variant='outlined'
                            size="medium"
                            sx={{
                              color: '#00B8D9',
                              padding: '0px 15px'
                            }}
                          >
                            Join
                          </Button>
                          <Button
                            disabled={match.status === 'cancelled'}
                            variant='outlined'
                            size="medium"
                            sx={{
                              color: '#00B8D9',
                              padding: '0px 15px'
                            }}
                          >
                            Watch
                          </Button>
                        </>
                      )

                      : (
                        <>
                          <Button
                            disabled={match.status === 'cancelled'}
                            variant='outlined'
                            size="medium"
                            sx={{
                              color: '#00B8D9',
                              padding: '0px 15px'
                            }}
                          >
                            Replay
                          </Button>
                          <Button
                            disabled={match.status === 'cancelled'}
                            variant='outlined'
                            size="medium"
                            sx={{
                              color: '#00B8D9',
                              padding: '0px 15px'
                            }}
                          >
                            Results
                          </Button>
                        </>
                      )
                    }
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </TableContainer>
      <TablePagination
        component="div"
        count={matchsCount}
        onPageChange={onPageChange}
        onRowsPerPageChange={onRowsPerPageChange}
        page={page}
        rowsPerPage={rowsPerPage}
        rowsPerPageOptions={[5, 10, 25]}
        sx={{ color: '#fff' }}
      />
    </Box>
  );
};

MatchList.propTypes = {
  matchs: PropTypes.any,
  matchsCount: PropTypes.number.isRequired,
  onPageChange: PropTypes.func.isRequired,
  onRowsPerPageChange: PropTypes.func,
  page: PropTypes.number.isRequired,
  rowsPerPage: PropTypes.number.isRequired,
};
