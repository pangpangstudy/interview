黑客松中的使用

```js
import { gql, request } from "graphql-request";
// const endpoint = 'https://api.studio.thegraph.com/query/76402/chaindraw/version/latest';
// export const graphQLClient = new GraphQLClient(endpoint);
// graphQLClient.request
// Graphql
const BASE_API_DEV =
  "https://api.studio.thegraph.com/query/76402/chaindraw/version/latest";
export const useExhibitLottery = (orderBy: string, orderDirection: string) => {
  return useQuery({
    queryKey: ["ExhibitLottery", orderBy, orderDirection],
    queryFn: async () =>
      await request(
        BASE_API_DEV,
        gql`
          query {
            lotteries(
              first: 3
              orderBy: "${orderBy}"
              orderDirection: "${orderDirection}"
            ) {
              id
              name
              ddl
              concertId
              completeDraw
              price
              remainingTicketCount
              ticketCount
              ticketType
              url
              organizer {
                id
              }
              nftMetadata {
                address
                concertName
                description
                image
                name
             }
            }
          }
        `
      ),

    refetchOnWindowFocus: false,
  });
};
```
