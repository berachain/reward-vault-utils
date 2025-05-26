
/**
 * Client
**/

import * as runtime from './runtime/library.js';
import $Types = runtime.Types // general types
import $Public = runtime.Types.Public
import $Utils = runtime.Types.Utils
import $Extensions = runtime.Types.Extensions
import $Result = runtime.Types.Result

export type PrismaPromise<T> = $Public.PrismaPromise<T>


/**
 * Model ButtonPress
 * 
 */
export type ButtonPress = $Result.DefaultSelection<Prisma.$ButtonPressPayload>
/**
 * Model RewardDistribution
 * 
 */
export type RewardDistribution = $Result.DefaultSelection<Prisma.$RewardDistributionPayload>

/**
 * ##  Prisma Client ʲˢ
 * 
 * Type-safe database client for TypeScript & Node.js
 * @example
 * ```
 * const prisma = new PrismaClient()
 * // Fetch zero or more ButtonPresses
 * const buttonPresses = await prisma.buttonPress.findMany()
 * ```
 *
 * 
 * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client).
 */
export class PrismaClient<
  ClientOptions extends Prisma.PrismaClientOptions = Prisma.PrismaClientOptions,
  U = 'log' extends keyof ClientOptions ? ClientOptions['log'] extends Array<Prisma.LogLevel | Prisma.LogDefinition> ? Prisma.GetEvents<ClientOptions['log']> : never : never,
  ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs
> {
  [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['other'] }

    /**
   * ##  Prisma Client ʲˢ
   * 
   * Type-safe database client for TypeScript & Node.js
   * @example
   * ```
   * const prisma = new PrismaClient()
   * // Fetch zero or more ButtonPresses
   * const buttonPresses = await prisma.buttonPress.findMany()
   * ```
   *
   * 
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client).
   */

  constructor(optionsArg ?: Prisma.Subset<ClientOptions, Prisma.PrismaClientOptions>);
  $on<V extends U>(eventType: V, callback: (event: V extends 'query' ? Prisma.QueryEvent : Prisma.LogEvent) => void): void;

  /**
   * Connect with the database
   */
  $connect(): $Utils.JsPromise<void>;

  /**
   * Disconnect from the database
   */
  $disconnect(): $Utils.JsPromise<void>;

  /**
   * Add a middleware
   * @deprecated since 4.16.0. For new code, prefer client extensions instead.
   * @see https://pris.ly/d/extensions
   */
  $use(cb: Prisma.Middleware): void

/**
   * Executes a prepared raw query and returns the number of affected rows.
   * @example
   * ```
   * const result = await prisma.$executeRaw`UPDATE User SET cool = ${true} WHERE email = ${'user@email.com'};`
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $executeRaw<T = unknown>(query: TemplateStringsArray | Prisma.Sql, ...values: any[]): Prisma.PrismaPromise<number>;

  /**
   * Executes a raw query and returns the number of affected rows.
   * Susceptible to SQL injections, see documentation.
   * @example
   * ```
   * const result = await prisma.$executeRawUnsafe('UPDATE User SET cool = $1 WHERE email = $2 ;', true, 'user@email.com')
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $executeRawUnsafe<T = unknown>(query: string, ...values: any[]): Prisma.PrismaPromise<number>;

  /**
   * Performs a prepared raw query and returns the `SELECT` data.
   * @example
   * ```
   * const result = await prisma.$queryRaw`SELECT * FROM User WHERE id = ${1} OR email = ${'user@email.com'};`
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $queryRaw<T = unknown>(query: TemplateStringsArray | Prisma.Sql, ...values: any[]): Prisma.PrismaPromise<T>;

  /**
   * Performs a raw query and returns the `SELECT` data.
   * Susceptible to SQL injections, see documentation.
   * @example
   * ```
   * const result = await prisma.$queryRawUnsafe('SELECT * FROM User WHERE id = $1 OR email = $2;', 1, 'user@email.com')
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $queryRawUnsafe<T = unknown>(query: string, ...values: any[]): Prisma.PrismaPromise<T>;


  /**
   * Allows the running of a sequence of read/write operations that are guaranteed to either succeed or fail as a whole.
   * @example
   * ```
   * const [george, bob, alice] = await prisma.$transaction([
   *   prisma.user.create({ data: { name: 'George' } }),
   *   prisma.user.create({ data: { name: 'Bob' } }),
   *   prisma.user.create({ data: { name: 'Alice' } }),
   * ])
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/concepts/components/prisma-client/transactions).
   */
  $transaction<P extends Prisma.PrismaPromise<any>[]>(arg: [...P], options?: { isolationLevel?: Prisma.TransactionIsolationLevel }): $Utils.JsPromise<runtime.Types.Utils.UnwrapTuple<P>>

  $transaction<R>(fn: (prisma: Omit<PrismaClient, runtime.ITXClientDenyList>) => $Utils.JsPromise<R>, options?: { maxWait?: number, timeout?: number, isolationLevel?: Prisma.TransactionIsolationLevel }): $Utils.JsPromise<R>


  $extends: $Extensions.ExtendsHook<"extends", Prisma.TypeMapCb, ExtArgs>

      /**
   * `prisma.buttonPress`: Exposes CRUD operations for the **ButtonPress** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more ButtonPresses
    * const buttonPresses = await prisma.buttonPress.findMany()
    * ```
    */
  get buttonPress(): Prisma.ButtonPressDelegate<ExtArgs>;

  /**
   * `prisma.rewardDistribution`: Exposes CRUD operations for the **RewardDistribution** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more RewardDistributions
    * const rewardDistributions = await prisma.rewardDistribution.findMany()
    * ```
    */
  get rewardDistribution(): Prisma.RewardDistributionDelegate<ExtArgs>;
}

export namespace Prisma {
  export import DMMF = runtime.DMMF

  export type PrismaPromise<T> = $Public.PrismaPromise<T>

  /**
   * Validator
   */
  export import validator = runtime.Public.validator

  /**
   * Prisma Errors
   */
  export import PrismaClientKnownRequestError = runtime.PrismaClientKnownRequestError
  export import PrismaClientUnknownRequestError = runtime.PrismaClientUnknownRequestError
  export import PrismaClientRustPanicError = runtime.PrismaClientRustPanicError
  export import PrismaClientInitializationError = runtime.PrismaClientInitializationError
  export import PrismaClientValidationError = runtime.PrismaClientValidationError
  export import NotFoundError = runtime.NotFoundError

  /**
   * Re-export of sql-template-tag
   */
  export import sql = runtime.sqltag
  export import empty = runtime.empty
  export import join = runtime.join
  export import raw = runtime.raw
  export import Sql = runtime.Sql



  /**
   * Decimal.js
   */
  export import Decimal = runtime.Decimal

  export type DecimalJsLike = runtime.DecimalJsLike

  /**
   * Metrics 
   */
  export type Metrics = runtime.Metrics
  export type Metric<T> = runtime.Metric<T>
  export type MetricHistogram = runtime.MetricHistogram
  export type MetricHistogramBucket = runtime.MetricHistogramBucket

  /**
  * Extensions
  */
  export import Extension = $Extensions.UserArgs
  export import getExtensionContext = runtime.Extensions.getExtensionContext
  export import Args = $Public.Args
  export import Payload = $Public.Payload
  export import Result = $Public.Result
  export import Exact = $Public.Exact

  /**
   * Prisma Client JS version: 5.22.0
   * Query Engine version: 605197351a3c8bdd595af2d2a9bc3025bca48ea2
   */
  export type PrismaVersion = {
    client: string
  }

  export const prismaVersion: PrismaVersion 

  /**
   * Utility Types
   */


  export import JsonObject = runtime.JsonObject
  export import JsonArray = runtime.JsonArray
  export import JsonValue = runtime.JsonValue
  export import InputJsonObject = runtime.InputJsonObject
  export import InputJsonArray = runtime.InputJsonArray
  export import InputJsonValue = runtime.InputJsonValue

  /**
   * Types of the values used to represent different kinds of `null` values when working with JSON fields.
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  namespace NullTypes {
    /**
    * Type of `Prisma.DbNull`.
    * 
    * You cannot use other instances of this class. Please use the `Prisma.DbNull` value.
    * 
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class DbNull {
      private DbNull: never
      private constructor()
    }

    /**
    * Type of `Prisma.JsonNull`.
    * 
    * You cannot use other instances of this class. Please use the `Prisma.JsonNull` value.
    * 
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class JsonNull {
      private JsonNull: never
      private constructor()
    }

    /**
    * Type of `Prisma.AnyNull`.
    * 
    * You cannot use other instances of this class. Please use the `Prisma.AnyNull` value.
    * 
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class AnyNull {
      private AnyNull: never
      private constructor()
    }
  }

  /**
   * Helper for filtering JSON entries that have `null` on the database (empty on the db)
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const DbNull: NullTypes.DbNull

  /**
   * Helper for filtering JSON entries that have JSON `null` values (not empty on the db)
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const JsonNull: NullTypes.JsonNull

  /**
   * Helper for filtering JSON entries that are `Prisma.DbNull` or `Prisma.JsonNull`
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const AnyNull: NullTypes.AnyNull

  type SelectAndInclude = {
    select: any
    include: any
  }

  type SelectAndOmit = {
    select: any
    omit: any
  }

  /**
   * Get the type of the value, that the Promise holds.
   */
  export type PromiseType<T extends PromiseLike<any>> = T extends PromiseLike<infer U> ? U : T;

  /**
   * Get the return type of a function which returns a Promise.
   */
  export type PromiseReturnType<T extends (...args: any) => $Utils.JsPromise<any>> = PromiseType<ReturnType<T>>

  /**
   * From T, pick a set of properties whose keys are in the union K
   */
  type Prisma__Pick<T, K extends keyof T> = {
      [P in K]: T[P];
  };


  export type Enumerable<T> = T | Array<T>;

  export type RequiredKeys<T> = {
    [K in keyof T]-?: {} extends Prisma__Pick<T, K> ? never : K
  }[keyof T]

  export type TruthyKeys<T> = keyof {
    [K in keyof T as T[K] extends false | undefined | null ? never : K]: K
  }

  export type TrueKeys<T> = TruthyKeys<Prisma__Pick<T, RequiredKeys<T>>>

  /**
   * Subset
   * @desc From `T` pick properties that exist in `U`. Simple version of Intersection
   */
  export type Subset<T, U> = {
    [key in keyof T]: key extends keyof U ? T[key] : never;
  };

  /**
   * SelectSubset
   * @desc From `T` pick properties that exist in `U`. Simple version of Intersection.
   * Additionally, it validates, if both select and include are present. If the case, it errors.
   */
  export type SelectSubset<T, U> = {
    [key in keyof T]: key extends keyof U ? T[key] : never
  } &
    (T extends SelectAndInclude
      ? 'Please either choose `select` or `include`.'
      : T extends SelectAndOmit
        ? 'Please either choose `select` or `omit`.'
        : {})

  /**
   * Subset + Intersection
   * @desc From `T` pick properties that exist in `U` and intersect `K`
   */
  export type SubsetIntersection<T, U, K> = {
    [key in keyof T]: key extends keyof U ? T[key] : never
  } &
    K

  type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never };

  /**
   * XOR is needed to have a real mutually exclusive union type
   * https://stackoverflow.com/questions/42123407/does-typescript-support-mutually-exclusive-types
   */
  type XOR<T, U> =
    T extends object ?
    U extends object ?
      (Without<T, U> & U) | (Without<U, T> & T)
    : U : T


  /**
   * Is T a Record?
   */
  type IsObject<T extends any> = T extends Array<any>
  ? False
  : T extends Date
  ? False
  : T extends Uint8Array
  ? False
  : T extends BigInt
  ? False
  : T extends object
  ? True
  : False


  /**
   * If it's T[], return T
   */
  export type UnEnumerate<T extends unknown> = T extends Array<infer U> ? U : T

  /**
   * From ts-toolbelt
   */

  type __Either<O extends object, K extends Key> = Omit<O, K> &
    {
      // Merge all but K
      [P in K]: Prisma__Pick<O, P & keyof O> // With K possibilities
    }[K]

  type EitherStrict<O extends object, K extends Key> = Strict<__Either<O, K>>

  type EitherLoose<O extends object, K extends Key> = ComputeRaw<__Either<O, K>>

  type _Either<
    O extends object,
    K extends Key,
    strict extends Boolean
  > = {
    1: EitherStrict<O, K>
    0: EitherLoose<O, K>
  }[strict]

  type Either<
    O extends object,
    K extends Key,
    strict extends Boolean = 1
  > = O extends unknown ? _Either<O, K, strict> : never

  export type Union = any

  type PatchUndefined<O extends object, O1 extends object> = {
    [K in keyof O]: O[K] extends undefined ? At<O1, K> : O[K]
  } & {}

  /** Helper Types for "Merge" **/
  export type IntersectOf<U extends Union> = (
    U extends unknown ? (k: U) => void : never
  ) extends (k: infer I) => void
    ? I
    : never

  export type Overwrite<O extends object, O1 extends object> = {
      [K in keyof O]: K extends keyof O1 ? O1[K] : O[K];
  } & {};

  type _Merge<U extends object> = IntersectOf<Overwrite<U, {
      [K in keyof U]-?: At<U, K>;
  }>>;

  type Key = string | number | symbol;
  type AtBasic<O extends object, K extends Key> = K extends keyof O ? O[K] : never;
  type AtStrict<O extends object, K extends Key> = O[K & keyof O];
  type AtLoose<O extends object, K extends Key> = O extends unknown ? AtStrict<O, K> : never;
  export type At<O extends object, K extends Key, strict extends Boolean = 1> = {
      1: AtStrict<O, K>;
      0: AtLoose<O, K>;
  }[strict];

  export type ComputeRaw<A extends any> = A extends Function ? A : {
    [K in keyof A]: A[K];
  } & {};

  export type OptionalFlat<O> = {
    [K in keyof O]?: O[K];
  } & {};

  type _Record<K extends keyof any, T> = {
    [P in K]: T;
  };

  // cause typescript not to expand types and preserve names
  type NoExpand<T> = T extends unknown ? T : never;

  // this type assumes the passed object is entirely optional
  type AtLeast<O extends object, K extends string> = NoExpand<
    O extends unknown
    ? | (K extends keyof O ? { [P in K]: O[P] } & O : O)
      | {[P in keyof O as P extends K ? K : never]-?: O[P]} & O
    : never>;

  type _Strict<U, _U = U> = U extends unknown ? U & OptionalFlat<_Record<Exclude<Keys<_U>, keyof U>, never>> : never;

  export type Strict<U extends object> = ComputeRaw<_Strict<U>>;
  /** End Helper Types for "Merge" **/

  export type Merge<U extends object> = ComputeRaw<_Merge<Strict<U>>>;

  /**
  A [[Boolean]]
  */
  export type Boolean = True | False

  // /**
  // 1
  // */
  export type True = 1

  /**
  0
  */
  export type False = 0

  export type Not<B extends Boolean> = {
    0: 1
    1: 0
  }[B]

  export type Extends<A1 extends any, A2 extends any> = [A1] extends [never]
    ? 0 // anything `never` is false
    : A1 extends A2
    ? 1
    : 0

  export type Has<U extends Union, U1 extends Union> = Not<
    Extends<Exclude<U1, U>, U1>
  >

  export type Or<B1 extends Boolean, B2 extends Boolean> = {
    0: {
      0: 0
      1: 1
    }
    1: {
      0: 1
      1: 1
    }
  }[B1][B2]

  export type Keys<U extends Union> = U extends unknown ? keyof U : never

  type Cast<A, B> = A extends B ? A : B;

  export const type: unique symbol;



  /**
   * Used by group by
   */

  export type GetScalarType<T, O> = O extends object ? {
    [P in keyof T]: P extends keyof O
      ? O[P]
      : never
  } : never

  type FieldPaths<
    T,
    U = Omit<T, '_avg' | '_sum' | '_count' | '_min' | '_max'>
  > = IsObject<T> extends True ? U : T

  type GetHavingFields<T> = {
    [K in keyof T]: Or<
      Or<Extends<'OR', K>, Extends<'AND', K>>,
      Extends<'NOT', K>
    > extends True
      ? // infer is only needed to not hit TS limit
        // based on the brilliant idea of Pierre-Antoine Mills
        // https://github.com/microsoft/TypeScript/issues/30188#issuecomment-478938437
        T[K] extends infer TK
        ? GetHavingFields<UnEnumerate<TK> extends object ? Merge<UnEnumerate<TK>> : never>
        : never
      : {} extends FieldPaths<T[K]>
      ? never
      : K
  }[keyof T]

  /**
   * Convert tuple to union
   */
  type _TupleToUnion<T> = T extends (infer E)[] ? E : never
  type TupleToUnion<K extends readonly any[]> = _TupleToUnion<K>
  type MaybeTupleToUnion<T> = T extends any[] ? TupleToUnion<T> : T

  /**
   * Like `Pick`, but additionally can also accept an array of keys
   */
  type PickEnumerable<T, K extends Enumerable<keyof T> | keyof T> = Prisma__Pick<T, MaybeTupleToUnion<K>>

  /**
   * Exclude all keys with underscores
   */
  type ExcludeUnderscoreKeys<T extends string> = T extends `_${string}` ? never : T


  export type FieldRef<Model, FieldType> = runtime.FieldRef<Model, FieldType>

  type FieldRefInputType<Model, FieldType> = Model extends never ? never : FieldRef<Model, FieldType>


  export const ModelName: {
    ButtonPress: 'ButtonPress',
    RewardDistribution: 'RewardDistribution'
  };

  export type ModelName = (typeof ModelName)[keyof typeof ModelName]


  export type Datasources = {
    db?: Datasource
  }

  interface TypeMapCb extends $Utils.Fn<{extArgs: $Extensions.InternalArgs, clientOptions: PrismaClientOptions }, $Utils.Record<string, any>> {
    returns: Prisma.TypeMap<this['params']['extArgs'], this['params']['clientOptions']>
  }

  export type TypeMap<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, ClientOptions = {}> = {
    meta: {
      modelProps: "buttonPress" | "rewardDistribution"
      txIsolationLevel: Prisma.TransactionIsolationLevel
    }
    model: {
      ButtonPress: {
        payload: Prisma.$ButtonPressPayload<ExtArgs>
        fields: Prisma.ButtonPressFieldRefs
        operations: {
          findUnique: {
            args: Prisma.ButtonPressFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.ButtonPressFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>
          }
          findFirst: {
            args: Prisma.ButtonPressFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.ButtonPressFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>
          }
          findMany: {
            args: Prisma.ButtonPressFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>[]
          }
          create: {
            args: Prisma.ButtonPressCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>
          }
          createMany: {
            args: Prisma.ButtonPressCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          createManyAndReturn: {
            args: Prisma.ButtonPressCreateManyAndReturnArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>[]
          }
          delete: {
            args: Prisma.ButtonPressDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>
          }
          update: {
            args: Prisma.ButtonPressUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>
          }
          deleteMany: {
            args: Prisma.ButtonPressDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.ButtonPressUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.ButtonPressUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$ButtonPressPayload>
          }
          aggregate: {
            args: Prisma.ButtonPressAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateButtonPress>
          }
          groupBy: {
            args: Prisma.ButtonPressGroupByArgs<ExtArgs>
            result: $Utils.Optional<ButtonPressGroupByOutputType>[]
          }
          count: {
            args: Prisma.ButtonPressCountArgs<ExtArgs>
            result: $Utils.Optional<ButtonPressCountAggregateOutputType> | number
          }
        }
      }
      RewardDistribution: {
        payload: Prisma.$RewardDistributionPayload<ExtArgs>
        fields: Prisma.RewardDistributionFieldRefs
        operations: {
          findUnique: {
            args: Prisma.RewardDistributionFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.RewardDistributionFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>
          }
          findFirst: {
            args: Prisma.RewardDistributionFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.RewardDistributionFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>
          }
          findMany: {
            args: Prisma.RewardDistributionFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>[]
          }
          create: {
            args: Prisma.RewardDistributionCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>
          }
          createMany: {
            args: Prisma.RewardDistributionCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          createManyAndReturn: {
            args: Prisma.RewardDistributionCreateManyAndReturnArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>[]
          }
          delete: {
            args: Prisma.RewardDistributionDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>
          }
          update: {
            args: Prisma.RewardDistributionUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>
          }
          deleteMany: {
            args: Prisma.RewardDistributionDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.RewardDistributionUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.RewardDistributionUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$RewardDistributionPayload>
          }
          aggregate: {
            args: Prisma.RewardDistributionAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateRewardDistribution>
          }
          groupBy: {
            args: Prisma.RewardDistributionGroupByArgs<ExtArgs>
            result: $Utils.Optional<RewardDistributionGroupByOutputType>[]
          }
          count: {
            args: Prisma.RewardDistributionCountArgs<ExtArgs>
            result: $Utils.Optional<RewardDistributionCountAggregateOutputType> | number
          }
        }
      }
    }
  } & {
    other: {
      payload: any
      operations: {
        $executeRaw: {
          args: [query: TemplateStringsArray | Prisma.Sql, ...values: any[]],
          result: any
        }
        $executeRawUnsafe: {
          args: [query: string, ...values: any[]],
          result: any
        }
        $queryRaw: {
          args: [query: TemplateStringsArray | Prisma.Sql, ...values: any[]],
          result: any
        }
        $queryRawUnsafe: {
          args: [query: string, ...values: any[]],
          result: any
        }
      }
    }
  }
  export const defineExtension: $Extensions.ExtendsHook<"define", Prisma.TypeMapCb, $Extensions.DefaultArgs>
  export type DefaultPrismaClient = PrismaClient
  export type ErrorFormat = 'pretty' | 'colorless' | 'minimal'
  export interface PrismaClientOptions {
    /**
     * Overwrites the datasource url from your schema.prisma file
     */
    datasources?: Datasources
    /**
     * Overwrites the datasource url from your schema.prisma file
     */
    datasourceUrl?: string
    /**
     * @default "colorless"
     */
    errorFormat?: ErrorFormat
    /**
     * @example
     * ```
     * // Defaults to stdout
     * log: ['query', 'info', 'warn', 'error']
     * 
     * // Emit as events
     * log: [
     *   { emit: 'stdout', level: 'query' },
     *   { emit: 'stdout', level: 'info' },
     *   { emit: 'stdout', level: 'warn' }
     *   { emit: 'stdout', level: 'error' }
     * ]
     * ```
     * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/logging#the-log-option).
     */
    log?: (LogLevel | LogDefinition)[]
    /**
     * The default values for transactionOptions
     * maxWait ?= 2000
     * timeout ?= 5000
     */
    transactionOptions?: {
      maxWait?: number
      timeout?: number
      isolationLevel?: Prisma.TransactionIsolationLevel
    }
  }


  /* Types for Logging */
  export type LogLevel = 'info' | 'query' | 'warn' | 'error'
  export type LogDefinition = {
    level: LogLevel
    emit: 'stdout' | 'event'
  }

  export type GetLogType<T extends LogLevel | LogDefinition> = T extends LogDefinition ? T['emit'] extends 'event' ? T['level'] : never : never
  export type GetEvents<T extends any> = T extends Array<LogLevel | LogDefinition> ?
    GetLogType<T[0]> | GetLogType<T[1]> | GetLogType<T[2]> | GetLogType<T[3]>
    : never

  export type QueryEvent = {
    timestamp: Date
    query: string
    params: string
    duration: number
    target: string
  }

  export type LogEvent = {
    timestamp: Date
    message: string
    target: string
  }
  /* End Types for Logging */


  export type PrismaAction =
    | 'findUnique'
    | 'findUniqueOrThrow'
    | 'findMany'
    | 'findFirst'
    | 'findFirstOrThrow'
    | 'create'
    | 'createMany'
    | 'createManyAndReturn'
    | 'update'
    | 'updateMany'
    | 'upsert'
    | 'delete'
    | 'deleteMany'
    | 'executeRaw'
    | 'queryRaw'
    | 'aggregate'
    | 'count'
    | 'runCommandRaw'
    | 'findRaw'
    | 'groupBy'

  /**
   * These options are being passed into the middleware as "params"
   */
  export type MiddlewareParams = {
    model?: ModelName
    action: PrismaAction
    args: any
    dataPath: string[]
    runInTransaction: boolean
  }

  /**
   * The `T` type makes sure, that the `return proceed` is not forgotten in the middleware implementation
   */
  export type Middleware<T = any> = (
    params: MiddlewareParams,
    next: (params: MiddlewareParams) => $Utils.JsPromise<T>,
  ) => $Utils.JsPromise<T>

  // tested in getLogLevel.test.ts
  export function getLogLevel(log: Array<LogLevel | LogDefinition>): LogLevel | undefined;

  /**
   * `PrismaClient` proxy available in interactive transactions.
   */
  export type TransactionClient = Omit<Prisma.DefaultPrismaClient, runtime.ITXClientDenyList>

  export type Datasource = {
    url?: string
  }

  /**
   * Count Types
   */



  /**
   * Models
   */

  /**
   * Model ButtonPress
   */

  export type AggregateButtonPress = {
    _count: ButtonPressCountAggregateOutputType | null
    _avg: ButtonPressAvgAggregateOutputType | null
    _sum: ButtonPressSumAggregateOutputType | null
    _min: ButtonPressMinAggregateOutputType | null
    _max: ButtonPressMaxAggregateOutputType | null
  }

  export type ButtonPressAvgAggregateOutputType = {
    blockNumber: number | null
  }

  export type ButtonPressSumAggregateOutputType = {
    blockNumber: number | null
  }

  export type ButtonPressMinAggregateOutputType = {
    id: string | null
    address: string | null
    timestamp: Date | null
    blockNumber: number | null
    txHash: string | null
    createdAt: Date | null
    updatedAt: Date | null
  }

  export type ButtonPressMaxAggregateOutputType = {
    id: string | null
    address: string | null
    timestamp: Date | null
    blockNumber: number | null
    txHash: string | null
    createdAt: Date | null
    updatedAt: Date | null
  }

  export type ButtonPressCountAggregateOutputType = {
    id: number
    address: number
    timestamp: number
    blockNumber: number
    txHash: number
    createdAt: number
    updatedAt: number
    _all: number
  }


  export type ButtonPressAvgAggregateInputType = {
    blockNumber?: true
  }

  export type ButtonPressSumAggregateInputType = {
    blockNumber?: true
  }

  export type ButtonPressMinAggregateInputType = {
    id?: true
    address?: true
    timestamp?: true
    blockNumber?: true
    txHash?: true
    createdAt?: true
    updatedAt?: true
  }

  export type ButtonPressMaxAggregateInputType = {
    id?: true
    address?: true
    timestamp?: true
    blockNumber?: true
    txHash?: true
    createdAt?: true
    updatedAt?: true
  }

  export type ButtonPressCountAggregateInputType = {
    id?: true
    address?: true
    timestamp?: true
    blockNumber?: true
    txHash?: true
    createdAt?: true
    updatedAt?: true
    _all?: true
  }

  export type ButtonPressAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which ButtonPress to aggregate.
     */
    where?: ButtonPressWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of ButtonPresses to fetch.
     */
    orderBy?: ButtonPressOrderByWithRelationInput | ButtonPressOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: ButtonPressWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` ButtonPresses from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` ButtonPresses.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned ButtonPresses
    **/
    _count?: true | ButtonPressCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: ButtonPressAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: ButtonPressSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: ButtonPressMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: ButtonPressMaxAggregateInputType
  }

  export type GetButtonPressAggregateType<T extends ButtonPressAggregateArgs> = {
        [P in keyof T & keyof AggregateButtonPress]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateButtonPress[P]>
      : GetScalarType<T[P], AggregateButtonPress[P]>
  }




  export type ButtonPressGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: ButtonPressWhereInput
    orderBy?: ButtonPressOrderByWithAggregationInput | ButtonPressOrderByWithAggregationInput[]
    by: ButtonPressScalarFieldEnum[] | ButtonPressScalarFieldEnum
    having?: ButtonPressScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: ButtonPressCountAggregateInputType | true
    _avg?: ButtonPressAvgAggregateInputType
    _sum?: ButtonPressSumAggregateInputType
    _min?: ButtonPressMinAggregateInputType
    _max?: ButtonPressMaxAggregateInputType
  }

  export type ButtonPressGroupByOutputType = {
    id: string
    address: string
    timestamp: Date
    blockNumber: number
    txHash: string
    createdAt: Date
    updatedAt: Date
    _count: ButtonPressCountAggregateOutputType | null
    _avg: ButtonPressAvgAggregateOutputType | null
    _sum: ButtonPressSumAggregateOutputType | null
    _min: ButtonPressMinAggregateOutputType | null
    _max: ButtonPressMaxAggregateOutputType | null
  }

  type GetButtonPressGroupByPayload<T extends ButtonPressGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<ButtonPressGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof ButtonPressGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], ButtonPressGroupByOutputType[P]>
            : GetScalarType<T[P], ButtonPressGroupByOutputType[P]>
        }
      >
    >


  export type ButtonPressSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    address?: boolean
    timestamp?: boolean
    blockNumber?: boolean
    txHash?: boolean
    createdAt?: boolean
    updatedAt?: boolean
  }, ExtArgs["result"]["buttonPress"]>

  export type ButtonPressSelectCreateManyAndReturn<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    address?: boolean
    timestamp?: boolean
    blockNumber?: boolean
    txHash?: boolean
    createdAt?: boolean
    updatedAt?: boolean
  }, ExtArgs["result"]["buttonPress"]>

  export type ButtonPressSelectScalar = {
    id?: boolean
    address?: boolean
    timestamp?: boolean
    blockNumber?: boolean
    txHash?: boolean
    createdAt?: boolean
    updatedAt?: boolean
  }


  export type $ButtonPressPayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "ButtonPress"
    objects: {}
    scalars: $Extensions.GetPayloadResult<{
      id: string
      address: string
      timestamp: Date
      blockNumber: number
      txHash: string
      createdAt: Date
      updatedAt: Date
    }, ExtArgs["result"]["buttonPress"]>
    composites: {}
  }

  type ButtonPressGetPayload<S extends boolean | null | undefined | ButtonPressDefaultArgs> = $Result.GetResult<Prisma.$ButtonPressPayload, S>

  type ButtonPressCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = 
    Omit<ButtonPressFindManyArgs, 'select' | 'include' | 'distinct'> & {
      select?: ButtonPressCountAggregateInputType | true
    }

  export interface ButtonPressDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['ButtonPress'], meta: { name: 'ButtonPress' } }
    /**
     * Find zero or one ButtonPress that matches the filter.
     * @param {ButtonPressFindUniqueArgs} args - Arguments to find a ButtonPress
     * @example
     * // Get one ButtonPress
     * const buttonPress = await prisma.buttonPress.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends ButtonPressFindUniqueArgs>(args: SelectSubset<T, ButtonPressFindUniqueArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "findUnique"> | null, null, ExtArgs>

    /**
     * Find one ButtonPress that matches the filter or throw an error with `error.code='P2025'` 
     * if no matches were found.
     * @param {ButtonPressFindUniqueOrThrowArgs} args - Arguments to find a ButtonPress
     * @example
     * // Get one ButtonPress
     * const buttonPress = await prisma.buttonPress.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends ButtonPressFindUniqueOrThrowArgs>(args: SelectSubset<T, ButtonPressFindUniqueOrThrowArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "findUniqueOrThrow">, never, ExtArgs>

    /**
     * Find the first ButtonPress that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressFindFirstArgs} args - Arguments to find a ButtonPress
     * @example
     * // Get one ButtonPress
     * const buttonPress = await prisma.buttonPress.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends ButtonPressFindFirstArgs>(args?: SelectSubset<T, ButtonPressFindFirstArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "findFirst"> | null, null, ExtArgs>

    /**
     * Find the first ButtonPress that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressFindFirstOrThrowArgs} args - Arguments to find a ButtonPress
     * @example
     * // Get one ButtonPress
     * const buttonPress = await prisma.buttonPress.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends ButtonPressFindFirstOrThrowArgs>(args?: SelectSubset<T, ButtonPressFindFirstOrThrowArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "findFirstOrThrow">, never, ExtArgs>

    /**
     * Find zero or more ButtonPresses that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all ButtonPresses
     * const buttonPresses = await prisma.buttonPress.findMany()
     * 
     * // Get first 10 ButtonPresses
     * const buttonPresses = await prisma.buttonPress.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const buttonPressWithIdOnly = await prisma.buttonPress.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends ButtonPressFindManyArgs>(args?: SelectSubset<T, ButtonPressFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "findMany">>

    /**
     * Create a ButtonPress.
     * @param {ButtonPressCreateArgs} args - Arguments to create a ButtonPress.
     * @example
     * // Create one ButtonPress
     * const ButtonPress = await prisma.buttonPress.create({
     *   data: {
     *     // ... data to create a ButtonPress
     *   }
     * })
     * 
     */
    create<T extends ButtonPressCreateArgs>(args: SelectSubset<T, ButtonPressCreateArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "create">, never, ExtArgs>

    /**
     * Create many ButtonPresses.
     * @param {ButtonPressCreateManyArgs} args - Arguments to create many ButtonPresses.
     * @example
     * // Create many ButtonPresses
     * const buttonPress = await prisma.buttonPress.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends ButtonPressCreateManyArgs>(args?: SelectSubset<T, ButtonPressCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create many ButtonPresses and returns the data saved in the database.
     * @param {ButtonPressCreateManyAndReturnArgs} args - Arguments to create many ButtonPresses.
     * @example
     * // Create many ButtonPresses
     * const buttonPress = await prisma.buttonPress.createManyAndReturn({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     * 
     * // Create many ButtonPresses and only return the `id`
     * const buttonPressWithIdOnly = await prisma.buttonPress.createManyAndReturn({ 
     *   select: { id: true },
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * 
     */
    createManyAndReturn<T extends ButtonPressCreateManyAndReturnArgs>(args?: SelectSubset<T, ButtonPressCreateManyAndReturnArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "createManyAndReturn">>

    /**
     * Delete a ButtonPress.
     * @param {ButtonPressDeleteArgs} args - Arguments to delete one ButtonPress.
     * @example
     * // Delete one ButtonPress
     * const ButtonPress = await prisma.buttonPress.delete({
     *   where: {
     *     // ... filter to delete one ButtonPress
     *   }
     * })
     * 
     */
    delete<T extends ButtonPressDeleteArgs>(args: SelectSubset<T, ButtonPressDeleteArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "delete">, never, ExtArgs>

    /**
     * Update one ButtonPress.
     * @param {ButtonPressUpdateArgs} args - Arguments to update one ButtonPress.
     * @example
     * // Update one ButtonPress
     * const buttonPress = await prisma.buttonPress.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends ButtonPressUpdateArgs>(args: SelectSubset<T, ButtonPressUpdateArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "update">, never, ExtArgs>

    /**
     * Delete zero or more ButtonPresses.
     * @param {ButtonPressDeleteManyArgs} args - Arguments to filter ButtonPresses to delete.
     * @example
     * // Delete a few ButtonPresses
     * const { count } = await prisma.buttonPress.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends ButtonPressDeleteManyArgs>(args?: SelectSubset<T, ButtonPressDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more ButtonPresses.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many ButtonPresses
     * const buttonPress = await prisma.buttonPress.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends ButtonPressUpdateManyArgs>(args: SelectSubset<T, ButtonPressUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one ButtonPress.
     * @param {ButtonPressUpsertArgs} args - Arguments to update or create a ButtonPress.
     * @example
     * // Update or create a ButtonPress
     * const buttonPress = await prisma.buttonPress.upsert({
     *   create: {
     *     // ... data to create a ButtonPress
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the ButtonPress we want to update
     *   }
     * })
     */
    upsert<T extends ButtonPressUpsertArgs>(args: SelectSubset<T, ButtonPressUpsertArgs<ExtArgs>>): Prisma__ButtonPressClient<$Result.GetResult<Prisma.$ButtonPressPayload<ExtArgs>, T, "upsert">, never, ExtArgs>


    /**
     * Count the number of ButtonPresses.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressCountArgs} args - Arguments to filter ButtonPresses to count.
     * @example
     * // Count the number of ButtonPresses
     * const count = await prisma.buttonPress.count({
     *   where: {
     *     // ... the filter for the ButtonPresses we want to count
     *   }
     * })
    **/
    count<T extends ButtonPressCountArgs>(
      args?: Subset<T, ButtonPressCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], ButtonPressCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a ButtonPress.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends ButtonPressAggregateArgs>(args: Subset<T, ButtonPressAggregateArgs>): Prisma.PrismaPromise<GetButtonPressAggregateType<T>>

    /**
     * Group by ButtonPress.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {ButtonPressGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends ButtonPressGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: ButtonPressGroupByArgs['orderBy'] }
        : { orderBy?: ButtonPressGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, ButtonPressGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetButtonPressGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the ButtonPress model
   */
  readonly fields: ButtonPressFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for ButtonPress.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__ButtonPressClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the ButtonPress model
   */ 
  interface ButtonPressFieldRefs {
    readonly id: FieldRef<"ButtonPress", 'String'>
    readonly address: FieldRef<"ButtonPress", 'String'>
    readonly timestamp: FieldRef<"ButtonPress", 'DateTime'>
    readonly blockNumber: FieldRef<"ButtonPress", 'Int'>
    readonly txHash: FieldRef<"ButtonPress", 'String'>
    readonly createdAt: FieldRef<"ButtonPress", 'DateTime'>
    readonly updatedAt: FieldRef<"ButtonPress", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * ButtonPress findUnique
   */
  export type ButtonPressFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * Filter, which ButtonPress to fetch.
     */
    where: ButtonPressWhereUniqueInput
  }

  /**
   * ButtonPress findUniqueOrThrow
   */
  export type ButtonPressFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * Filter, which ButtonPress to fetch.
     */
    where: ButtonPressWhereUniqueInput
  }

  /**
   * ButtonPress findFirst
   */
  export type ButtonPressFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * Filter, which ButtonPress to fetch.
     */
    where?: ButtonPressWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of ButtonPresses to fetch.
     */
    orderBy?: ButtonPressOrderByWithRelationInput | ButtonPressOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for ButtonPresses.
     */
    cursor?: ButtonPressWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` ButtonPresses from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` ButtonPresses.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of ButtonPresses.
     */
    distinct?: ButtonPressScalarFieldEnum | ButtonPressScalarFieldEnum[]
  }

  /**
   * ButtonPress findFirstOrThrow
   */
  export type ButtonPressFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * Filter, which ButtonPress to fetch.
     */
    where?: ButtonPressWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of ButtonPresses to fetch.
     */
    orderBy?: ButtonPressOrderByWithRelationInput | ButtonPressOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for ButtonPresses.
     */
    cursor?: ButtonPressWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` ButtonPresses from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` ButtonPresses.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of ButtonPresses.
     */
    distinct?: ButtonPressScalarFieldEnum | ButtonPressScalarFieldEnum[]
  }

  /**
   * ButtonPress findMany
   */
  export type ButtonPressFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * Filter, which ButtonPresses to fetch.
     */
    where?: ButtonPressWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of ButtonPresses to fetch.
     */
    orderBy?: ButtonPressOrderByWithRelationInput | ButtonPressOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing ButtonPresses.
     */
    cursor?: ButtonPressWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` ButtonPresses from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` ButtonPresses.
     */
    skip?: number
    distinct?: ButtonPressScalarFieldEnum | ButtonPressScalarFieldEnum[]
  }

  /**
   * ButtonPress create
   */
  export type ButtonPressCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * The data needed to create a ButtonPress.
     */
    data: XOR<ButtonPressCreateInput, ButtonPressUncheckedCreateInput>
  }

  /**
   * ButtonPress createMany
   */
  export type ButtonPressCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many ButtonPresses.
     */
    data: ButtonPressCreateManyInput | ButtonPressCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * ButtonPress createManyAndReturn
   */
  export type ButtonPressCreateManyAndReturnArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelectCreateManyAndReturn<ExtArgs> | null
    /**
     * The data used to create many ButtonPresses.
     */
    data: ButtonPressCreateManyInput | ButtonPressCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * ButtonPress update
   */
  export type ButtonPressUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * The data needed to update a ButtonPress.
     */
    data: XOR<ButtonPressUpdateInput, ButtonPressUncheckedUpdateInput>
    /**
     * Choose, which ButtonPress to update.
     */
    where: ButtonPressWhereUniqueInput
  }

  /**
   * ButtonPress updateMany
   */
  export type ButtonPressUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update ButtonPresses.
     */
    data: XOR<ButtonPressUpdateManyMutationInput, ButtonPressUncheckedUpdateManyInput>
    /**
     * Filter which ButtonPresses to update
     */
    where?: ButtonPressWhereInput
  }

  /**
   * ButtonPress upsert
   */
  export type ButtonPressUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * The filter to search for the ButtonPress to update in case it exists.
     */
    where: ButtonPressWhereUniqueInput
    /**
     * In case the ButtonPress found by the `where` argument doesn't exist, create a new ButtonPress with this data.
     */
    create: XOR<ButtonPressCreateInput, ButtonPressUncheckedCreateInput>
    /**
     * In case the ButtonPress was found with the provided `where` argument, update it with this data.
     */
    update: XOR<ButtonPressUpdateInput, ButtonPressUncheckedUpdateInput>
  }

  /**
   * ButtonPress delete
   */
  export type ButtonPressDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
    /**
     * Filter which ButtonPress to delete.
     */
    where: ButtonPressWhereUniqueInput
  }

  /**
   * ButtonPress deleteMany
   */
  export type ButtonPressDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which ButtonPresses to delete
     */
    where?: ButtonPressWhereInput
  }

  /**
   * ButtonPress without action
   */
  export type ButtonPressDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the ButtonPress
     */
    select?: ButtonPressSelect<ExtArgs> | null
  }


  /**
   * Model RewardDistribution
   */

  export type AggregateRewardDistribution = {
    _count: RewardDistributionCountAggregateOutputType | null
    _min: RewardDistributionMinAggregateOutputType | null
    _max: RewardDistributionMaxAggregateOutputType | null
  }

  export type RewardDistributionMinAggregateOutputType = {
    id: string | null
    startTime: Date | null
    endTime: Date | null
    totalRewards: string | null
    merkleRoot: string | null
    createdAt: Date | null
    updatedAt: Date | null
  }

  export type RewardDistributionMaxAggregateOutputType = {
    id: string | null
    startTime: Date | null
    endTime: Date | null
    totalRewards: string | null
    merkleRoot: string | null
    createdAt: Date | null
    updatedAt: Date | null
  }

  export type RewardDistributionCountAggregateOutputType = {
    id: number
    startTime: number
    endTime: number
    totalRewards: number
    merkleRoot: number
    merkleProofs: number
    createdAt: number
    updatedAt: number
    _all: number
  }


  export type RewardDistributionMinAggregateInputType = {
    id?: true
    startTime?: true
    endTime?: true
    totalRewards?: true
    merkleRoot?: true
    createdAt?: true
    updatedAt?: true
  }

  export type RewardDistributionMaxAggregateInputType = {
    id?: true
    startTime?: true
    endTime?: true
    totalRewards?: true
    merkleRoot?: true
    createdAt?: true
    updatedAt?: true
  }

  export type RewardDistributionCountAggregateInputType = {
    id?: true
    startTime?: true
    endTime?: true
    totalRewards?: true
    merkleRoot?: true
    merkleProofs?: true
    createdAt?: true
    updatedAt?: true
    _all?: true
  }

  export type RewardDistributionAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which RewardDistribution to aggregate.
     */
    where?: RewardDistributionWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of RewardDistributions to fetch.
     */
    orderBy?: RewardDistributionOrderByWithRelationInput | RewardDistributionOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: RewardDistributionWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` RewardDistributions from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` RewardDistributions.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned RewardDistributions
    **/
    _count?: true | RewardDistributionCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: RewardDistributionMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: RewardDistributionMaxAggregateInputType
  }

  export type GetRewardDistributionAggregateType<T extends RewardDistributionAggregateArgs> = {
        [P in keyof T & keyof AggregateRewardDistribution]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateRewardDistribution[P]>
      : GetScalarType<T[P], AggregateRewardDistribution[P]>
  }




  export type RewardDistributionGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: RewardDistributionWhereInput
    orderBy?: RewardDistributionOrderByWithAggregationInput | RewardDistributionOrderByWithAggregationInput[]
    by: RewardDistributionScalarFieldEnum[] | RewardDistributionScalarFieldEnum
    having?: RewardDistributionScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: RewardDistributionCountAggregateInputType | true
    _min?: RewardDistributionMinAggregateInputType
    _max?: RewardDistributionMaxAggregateInputType
  }

  export type RewardDistributionGroupByOutputType = {
    id: string
    startTime: Date
    endTime: Date
    totalRewards: string
    merkleRoot: string
    merkleProofs: JsonValue
    createdAt: Date
    updatedAt: Date
    _count: RewardDistributionCountAggregateOutputType | null
    _min: RewardDistributionMinAggregateOutputType | null
    _max: RewardDistributionMaxAggregateOutputType | null
  }

  type GetRewardDistributionGroupByPayload<T extends RewardDistributionGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<RewardDistributionGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof RewardDistributionGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], RewardDistributionGroupByOutputType[P]>
            : GetScalarType<T[P], RewardDistributionGroupByOutputType[P]>
        }
      >
    >


  export type RewardDistributionSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    startTime?: boolean
    endTime?: boolean
    totalRewards?: boolean
    merkleRoot?: boolean
    merkleProofs?: boolean
    createdAt?: boolean
    updatedAt?: boolean
  }, ExtArgs["result"]["rewardDistribution"]>

  export type RewardDistributionSelectCreateManyAndReturn<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    startTime?: boolean
    endTime?: boolean
    totalRewards?: boolean
    merkleRoot?: boolean
    merkleProofs?: boolean
    createdAt?: boolean
    updatedAt?: boolean
  }, ExtArgs["result"]["rewardDistribution"]>

  export type RewardDistributionSelectScalar = {
    id?: boolean
    startTime?: boolean
    endTime?: boolean
    totalRewards?: boolean
    merkleRoot?: boolean
    merkleProofs?: boolean
    createdAt?: boolean
    updatedAt?: boolean
  }


  export type $RewardDistributionPayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "RewardDistribution"
    objects: {}
    scalars: $Extensions.GetPayloadResult<{
      id: string
      startTime: Date
      endTime: Date
      totalRewards: string
      merkleRoot: string
      merkleProofs: Prisma.JsonValue
      createdAt: Date
      updatedAt: Date
    }, ExtArgs["result"]["rewardDistribution"]>
    composites: {}
  }

  type RewardDistributionGetPayload<S extends boolean | null | undefined | RewardDistributionDefaultArgs> = $Result.GetResult<Prisma.$RewardDistributionPayload, S>

  type RewardDistributionCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = 
    Omit<RewardDistributionFindManyArgs, 'select' | 'include' | 'distinct'> & {
      select?: RewardDistributionCountAggregateInputType | true
    }

  export interface RewardDistributionDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['RewardDistribution'], meta: { name: 'RewardDistribution' } }
    /**
     * Find zero or one RewardDistribution that matches the filter.
     * @param {RewardDistributionFindUniqueArgs} args - Arguments to find a RewardDistribution
     * @example
     * // Get one RewardDistribution
     * const rewardDistribution = await prisma.rewardDistribution.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends RewardDistributionFindUniqueArgs>(args: SelectSubset<T, RewardDistributionFindUniqueArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "findUnique"> | null, null, ExtArgs>

    /**
     * Find one RewardDistribution that matches the filter or throw an error with `error.code='P2025'` 
     * if no matches were found.
     * @param {RewardDistributionFindUniqueOrThrowArgs} args - Arguments to find a RewardDistribution
     * @example
     * // Get one RewardDistribution
     * const rewardDistribution = await prisma.rewardDistribution.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends RewardDistributionFindUniqueOrThrowArgs>(args: SelectSubset<T, RewardDistributionFindUniqueOrThrowArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "findUniqueOrThrow">, never, ExtArgs>

    /**
     * Find the first RewardDistribution that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionFindFirstArgs} args - Arguments to find a RewardDistribution
     * @example
     * // Get one RewardDistribution
     * const rewardDistribution = await prisma.rewardDistribution.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends RewardDistributionFindFirstArgs>(args?: SelectSubset<T, RewardDistributionFindFirstArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "findFirst"> | null, null, ExtArgs>

    /**
     * Find the first RewardDistribution that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionFindFirstOrThrowArgs} args - Arguments to find a RewardDistribution
     * @example
     * // Get one RewardDistribution
     * const rewardDistribution = await prisma.rewardDistribution.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends RewardDistributionFindFirstOrThrowArgs>(args?: SelectSubset<T, RewardDistributionFindFirstOrThrowArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "findFirstOrThrow">, never, ExtArgs>

    /**
     * Find zero or more RewardDistributions that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all RewardDistributions
     * const rewardDistributions = await prisma.rewardDistribution.findMany()
     * 
     * // Get first 10 RewardDistributions
     * const rewardDistributions = await prisma.rewardDistribution.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const rewardDistributionWithIdOnly = await prisma.rewardDistribution.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends RewardDistributionFindManyArgs>(args?: SelectSubset<T, RewardDistributionFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "findMany">>

    /**
     * Create a RewardDistribution.
     * @param {RewardDistributionCreateArgs} args - Arguments to create a RewardDistribution.
     * @example
     * // Create one RewardDistribution
     * const RewardDistribution = await prisma.rewardDistribution.create({
     *   data: {
     *     // ... data to create a RewardDistribution
     *   }
     * })
     * 
     */
    create<T extends RewardDistributionCreateArgs>(args: SelectSubset<T, RewardDistributionCreateArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "create">, never, ExtArgs>

    /**
     * Create many RewardDistributions.
     * @param {RewardDistributionCreateManyArgs} args - Arguments to create many RewardDistributions.
     * @example
     * // Create many RewardDistributions
     * const rewardDistribution = await prisma.rewardDistribution.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends RewardDistributionCreateManyArgs>(args?: SelectSubset<T, RewardDistributionCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create many RewardDistributions and returns the data saved in the database.
     * @param {RewardDistributionCreateManyAndReturnArgs} args - Arguments to create many RewardDistributions.
     * @example
     * // Create many RewardDistributions
     * const rewardDistribution = await prisma.rewardDistribution.createManyAndReturn({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     * 
     * // Create many RewardDistributions and only return the `id`
     * const rewardDistributionWithIdOnly = await prisma.rewardDistribution.createManyAndReturn({ 
     *   select: { id: true },
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * 
     */
    createManyAndReturn<T extends RewardDistributionCreateManyAndReturnArgs>(args?: SelectSubset<T, RewardDistributionCreateManyAndReturnArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "createManyAndReturn">>

    /**
     * Delete a RewardDistribution.
     * @param {RewardDistributionDeleteArgs} args - Arguments to delete one RewardDistribution.
     * @example
     * // Delete one RewardDistribution
     * const RewardDistribution = await prisma.rewardDistribution.delete({
     *   where: {
     *     // ... filter to delete one RewardDistribution
     *   }
     * })
     * 
     */
    delete<T extends RewardDistributionDeleteArgs>(args: SelectSubset<T, RewardDistributionDeleteArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "delete">, never, ExtArgs>

    /**
     * Update one RewardDistribution.
     * @param {RewardDistributionUpdateArgs} args - Arguments to update one RewardDistribution.
     * @example
     * // Update one RewardDistribution
     * const rewardDistribution = await prisma.rewardDistribution.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends RewardDistributionUpdateArgs>(args: SelectSubset<T, RewardDistributionUpdateArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "update">, never, ExtArgs>

    /**
     * Delete zero or more RewardDistributions.
     * @param {RewardDistributionDeleteManyArgs} args - Arguments to filter RewardDistributions to delete.
     * @example
     * // Delete a few RewardDistributions
     * const { count } = await prisma.rewardDistribution.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends RewardDistributionDeleteManyArgs>(args?: SelectSubset<T, RewardDistributionDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more RewardDistributions.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many RewardDistributions
     * const rewardDistribution = await prisma.rewardDistribution.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends RewardDistributionUpdateManyArgs>(args: SelectSubset<T, RewardDistributionUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one RewardDistribution.
     * @param {RewardDistributionUpsertArgs} args - Arguments to update or create a RewardDistribution.
     * @example
     * // Update or create a RewardDistribution
     * const rewardDistribution = await prisma.rewardDistribution.upsert({
     *   create: {
     *     // ... data to create a RewardDistribution
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the RewardDistribution we want to update
     *   }
     * })
     */
    upsert<T extends RewardDistributionUpsertArgs>(args: SelectSubset<T, RewardDistributionUpsertArgs<ExtArgs>>): Prisma__RewardDistributionClient<$Result.GetResult<Prisma.$RewardDistributionPayload<ExtArgs>, T, "upsert">, never, ExtArgs>


    /**
     * Count the number of RewardDistributions.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionCountArgs} args - Arguments to filter RewardDistributions to count.
     * @example
     * // Count the number of RewardDistributions
     * const count = await prisma.rewardDistribution.count({
     *   where: {
     *     // ... the filter for the RewardDistributions we want to count
     *   }
     * })
    **/
    count<T extends RewardDistributionCountArgs>(
      args?: Subset<T, RewardDistributionCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], RewardDistributionCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a RewardDistribution.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends RewardDistributionAggregateArgs>(args: Subset<T, RewardDistributionAggregateArgs>): Prisma.PrismaPromise<GetRewardDistributionAggregateType<T>>

    /**
     * Group by RewardDistribution.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {RewardDistributionGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends RewardDistributionGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: RewardDistributionGroupByArgs['orderBy'] }
        : { orderBy?: RewardDistributionGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, RewardDistributionGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetRewardDistributionGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the RewardDistribution model
   */
  readonly fields: RewardDistributionFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for RewardDistribution.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__RewardDistributionClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the RewardDistribution model
   */ 
  interface RewardDistributionFieldRefs {
    readonly id: FieldRef<"RewardDistribution", 'String'>
    readonly startTime: FieldRef<"RewardDistribution", 'DateTime'>
    readonly endTime: FieldRef<"RewardDistribution", 'DateTime'>
    readonly totalRewards: FieldRef<"RewardDistribution", 'String'>
    readonly merkleRoot: FieldRef<"RewardDistribution", 'String'>
    readonly merkleProofs: FieldRef<"RewardDistribution", 'Json'>
    readonly createdAt: FieldRef<"RewardDistribution", 'DateTime'>
    readonly updatedAt: FieldRef<"RewardDistribution", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * RewardDistribution findUnique
   */
  export type RewardDistributionFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * Filter, which RewardDistribution to fetch.
     */
    where: RewardDistributionWhereUniqueInput
  }

  /**
   * RewardDistribution findUniqueOrThrow
   */
  export type RewardDistributionFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * Filter, which RewardDistribution to fetch.
     */
    where: RewardDistributionWhereUniqueInput
  }

  /**
   * RewardDistribution findFirst
   */
  export type RewardDistributionFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * Filter, which RewardDistribution to fetch.
     */
    where?: RewardDistributionWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of RewardDistributions to fetch.
     */
    orderBy?: RewardDistributionOrderByWithRelationInput | RewardDistributionOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for RewardDistributions.
     */
    cursor?: RewardDistributionWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` RewardDistributions from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` RewardDistributions.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of RewardDistributions.
     */
    distinct?: RewardDistributionScalarFieldEnum | RewardDistributionScalarFieldEnum[]
  }

  /**
   * RewardDistribution findFirstOrThrow
   */
  export type RewardDistributionFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * Filter, which RewardDistribution to fetch.
     */
    where?: RewardDistributionWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of RewardDistributions to fetch.
     */
    orderBy?: RewardDistributionOrderByWithRelationInput | RewardDistributionOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for RewardDistributions.
     */
    cursor?: RewardDistributionWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` RewardDistributions from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` RewardDistributions.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of RewardDistributions.
     */
    distinct?: RewardDistributionScalarFieldEnum | RewardDistributionScalarFieldEnum[]
  }

  /**
   * RewardDistribution findMany
   */
  export type RewardDistributionFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * Filter, which RewardDistributions to fetch.
     */
    where?: RewardDistributionWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of RewardDistributions to fetch.
     */
    orderBy?: RewardDistributionOrderByWithRelationInput | RewardDistributionOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing RewardDistributions.
     */
    cursor?: RewardDistributionWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` RewardDistributions from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` RewardDistributions.
     */
    skip?: number
    distinct?: RewardDistributionScalarFieldEnum | RewardDistributionScalarFieldEnum[]
  }

  /**
   * RewardDistribution create
   */
  export type RewardDistributionCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * The data needed to create a RewardDistribution.
     */
    data: XOR<RewardDistributionCreateInput, RewardDistributionUncheckedCreateInput>
  }

  /**
   * RewardDistribution createMany
   */
  export type RewardDistributionCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many RewardDistributions.
     */
    data: RewardDistributionCreateManyInput | RewardDistributionCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * RewardDistribution createManyAndReturn
   */
  export type RewardDistributionCreateManyAndReturnArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelectCreateManyAndReturn<ExtArgs> | null
    /**
     * The data used to create many RewardDistributions.
     */
    data: RewardDistributionCreateManyInput | RewardDistributionCreateManyInput[]
    skipDuplicates?: boolean
  }

  /**
   * RewardDistribution update
   */
  export type RewardDistributionUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * The data needed to update a RewardDistribution.
     */
    data: XOR<RewardDistributionUpdateInput, RewardDistributionUncheckedUpdateInput>
    /**
     * Choose, which RewardDistribution to update.
     */
    where: RewardDistributionWhereUniqueInput
  }

  /**
   * RewardDistribution updateMany
   */
  export type RewardDistributionUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update RewardDistributions.
     */
    data: XOR<RewardDistributionUpdateManyMutationInput, RewardDistributionUncheckedUpdateManyInput>
    /**
     * Filter which RewardDistributions to update
     */
    where?: RewardDistributionWhereInput
  }

  /**
   * RewardDistribution upsert
   */
  export type RewardDistributionUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * The filter to search for the RewardDistribution to update in case it exists.
     */
    where: RewardDistributionWhereUniqueInput
    /**
     * In case the RewardDistribution found by the `where` argument doesn't exist, create a new RewardDistribution with this data.
     */
    create: XOR<RewardDistributionCreateInput, RewardDistributionUncheckedCreateInput>
    /**
     * In case the RewardDistribution was found with the provided `where` argument, update it with this data.
     */
    update: XOR<RewardDistributionUpdateInput, RewardDistributionUncheckedUpdateInput>
  }

  /**
   * RewardDistribution delete
   */
  export type RewardDistributionDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
    /**
     * Filter which RewardDistribution to delete.
     */
    where: RewardDistributionWhereUniqueInput
  }

  /**
   * RewardDistribution deleteMany
   */
  export type RewardDistributionDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which RewardDistributions to delete
     */
    where?: RewardDistributionWhereInput
  }

  /**
   * RewardDistribution without action
   */
  export type RewardDistributionDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the RewardDistribution
     */
    select?: RewardDistributionSelect<ExtArgs> | null
  }


  /**
   * Enums
   */

  export const TransactionIsolationLevel: {
    ReadUncommitted: 'ReadUncommitted',
    ReadCommitted: 'ReadCommitted',
    RepeatableRead: 'RepeatableRead',
    Serializable: 'Serializable'
  };

  export type TransactionIsolationLevel = (typeof TransactionIsolationLevel)[keyof typeof TransactionIsolationLevel]


  export const ButtonPressScalarFieldEnum: {
    id: 'id',
    address: 'address',
    timestamp: 'timestamp',
    blockNumber: 'blockNumber',
    txHash: 'txHash',
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  };

  export type ButtonPressScalarFieldEnum = (typeof ButtonPressScalarFieldEnum)[keyof typeof ButtonPressScalarFieldEnum]


  export const RewardDistributionScalarFieldEnum: {
    id: 'id',
    startTime: 'startTime',
    endTime: 'endTime',
    totalRewards: 'totalRewards',
    merkleRoot: 'merkleRoot',
    merkleProofs: 'merkleProofs',
    createdAt: 'createdAt',
    updatedAt: 'updatedAt'
  };

  export type RewardDistributionScalarFieldEnum = (typeof RewardDistributionScalarFieldEnum)[keyof typeof RewardDistributionScalarFieldEnum]


  export const SortOrder: {
    asc: 'asc',
    desc: 'desc'
  };

  export type SortOrder = (typeof SortOrder)[keyof typeof SortOrder]


  export const JsonNullValueInput: {
    JsonNull: typeof JsonNull
  };

  export type JsonNullValueInput = (typeof JsonNullValueInput)[keyof typeof JsonNullValueInput]


  export const QueryMode: {
    default: 'default',
    insensitive: 'insensitive'
  };

  export type QueryMode = (typeof QueryMode)[keyof typeof QueryMode]


  export const JsonNullValueFilter: {
    DbNull: typeof DbNull,
    JsonNull: typeof JsonNull,
    AnyNull: typeof AnyNull
  };

  export type JsonNullValueFilter = (typeof JsonNullValueFilter)[keyof typeof JsonNullValueFilter]


  /**
   * Field references 
   */


  /**
   * Reference to a field of type 'String'
   */
  export type StringFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'String'>
    


  /**
   * Reference to a field of type 'String[]'
   */
  export type ListStringFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'String[]'>
    


  /**
   * Reference to a field of type 'DateTime'
   */
  export type DateTimeFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'DateTime'>
    


  /**
   * Reference to a field of type 'DateTime[]'
   */
  export type ListDateTimeFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'DateTime[]'>
    


  /**
   * Reference to a field of type 'Int'
   */
  export type IntFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Int'>
    


  /**
   * Reference to a field of type 'Int[]'
   */
  export type ListIntFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Int[]'>
    


  /**
   * Reference to a field of type 'Json'
   */
  export type JsonFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Json'>
    


  /**
   * Reference to a field of type 'Float'
   */
  export type FloatFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Float'>
    


  /**
   * Reference to a field of type 'Float[]'
   */
  export type ListFloatFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Float[]'>
    
  /**
   * Deep Input Types
   */


  export type ButtonPressWhereInput = {
    AND?: ButtonPressWhereInput | ButtonPressWhereInput[]
    OR?: ButtonPressWhereInput[]
    NOT?: ButtonPressWhereInput | ButtonPressWhereInput[]
    id?: StringFilter<"ButtonPress"> | string
    address?: StringFilter<"ButtonPress"> | string
    timestamp?: DateTimeFilter<"ButtonPress"> | Date | string
    blockNumber?: IntFilter<"ButtonPress"> | number
    txHash?: StringFilter<"ButtonPress"> | string
    createdAt?: DateTimeFilter<"ButtonPress"> | Date | string
    updatedAt?: DateTimeFilter<"ButtonPress"> | Date | string
  }

  export type ButtonPressOrderByWithRelationInput = {
    id?: SortOrder
    address?: SortOrder
    timestamp?: SortOrder
    blockNumber?: SortOrder
    txHash?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type ButtonPressWhereUniqueInput = Prisma.AtLeast<{
    id?: string
    txHash?: string
    AND?: ButtonPressWhereInput | ButtonPressWhereInput[]
    OR?: ButtonPressWhereInput[]
    NOT?: ButtonPressWhereInput | ButtonPressWhereInput[]
    address?: StringFilter<"ButtonPress"> | string
    timestamp?: DateTimeFilter<"ButtonPress"> | Date | string
    blockNumber?: IntFilter<"ButtonPress"> | number
    createdAt?: DateTimeFilter<"ButtonPress"> | Date | string
    updatedAt?: DateTimeFilter<"ButtonPress"> | Date | string
  }, "id" | "txHash">

  export type ButtonPressOrderByWithAggregationInput = {
    id?: SortOrder
    address?: SortOrder
    timestamp?: SortOrder
    blockNumber?: SortOrder
    txHash?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
    _count?: ButtonPressCountOrderByAggregateInput
    _avg?: ButtonPressAvgOrderByAggregateInput
    _max?: ButtonPressMaxOrderByAggregateInput
    _min?: ButtonPressMinOrderByAggregateInput
    _sum?: ButtonPressSumOrderByAggregateInput
  }

  export type ButtonPressScalarWhereWithAggregatesInput = {
    AND?: ButtonPressScalarWhereWithAggregatesInput | ButtonPressScalarWhereWithAggregatesInput[]
    OR?: ButtonPressScalarWhereWithAggregatesInput[]
    NOT?: ButtonPressScalarWhereWithAggregatesInput | ButtonPressScalarWhereWithAggregatesInput[]
    id?: StringWithAggregatesFilter<"ButtonPress"> | string
    address?: StringWithAggregatesFilter<"ButtonPress"> | string
    timestamp?: DateTimeWithAggregatesFilter<"ButtonPress"> | Date | string
    blockNumber?: IntWithAggregatesFilter<"ButtonPress"> | number
    txHash?: StringWithAggregatesFilter<"ButtonPress"> | string
    createdAt?: DateTimeWithAggregatesFilter<"ButtonPress"> | Date | string
    updatedAt?: DateTimeWithAggregatesFilter<"ButtonPress"> | Date | string
  }

  export type RewardDistributionWhereInput = {
    AND?: RewardDistributionWhereInput | RewardDistributionWhereInput[]
    OR?: RewardDistributionWhereInput[]
    NOT?: RewardDistributionWhereInput | RewardDistributionWhereInput[]
    id?: StringFilter<"RewardDistribution"> | string
    startTime?: DateTimeFilter<"RewardDistribution"> | Date | string
    endTime?: DateTimeFilter<"RewardDistribution"> | Date | string
    totalRewards?: StringFilter<"RewardDistribution"> | string
    merkleRoot?: StringFilter<"RewardDistribution"> | string
    merkleProofs?: JsonFilter<"RewardDistribution">
    createdAt?: DateTimeFilter<"RewardDistribution"> | Date | string
    updatedAt?: DateTimeFilter<"RewardDistribution"> | Date | string
  }

  export type RewardDistributionOrderByWithRelationInput = {
    id?: SortOrder
    startTime?: SortOrder
    endTime?: SortOrder
    totalRewards?: SortOrder
    merkleRoot?: SortOrder
    merkleProofs?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type RewardDistributionWhereUniqueInput = Prisma.AtLeast<{
    id?: string
    AND?: RewardDistributionWhereInput | RewardDistributionWhereInput[]
    OR?: RewardDistributionWhereInput[]
    NOT?: RewardDistributionWhereInput | RewardDistributionWhereInput[]
    startTime?: DateTimeFilter<"RewardDistribution"> | Date | string
    endTime?: DateTimeFilter<"RewardDistribution"> | Date | string
    totalRewards?: StringFilter<"RewardDistribution"> | string
    merkleRoot?: StringFilter<"RewardDistribution"> | string
    merkleProofs?: JsonFilter<"RewardDistribution">
    createdAt?: DateTimeFilter<"RewardDistribution"> | Date | string
    updatedAt?: DateTimeFilter<"RewardDistribution"> | Date | string
  }, "id">

  export type RewardDistributionOrderByWithAggregationInput = {
    id?: SortOrder
    startTime?: SortOrder
    endTime?: SortOrder
    totalRewards?: SortOrder
    merkleRoot?: SortOrder
    merkleProofs?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
    _count?: RewardDistributionCountOrderByAggregateInput
    _max?: RewardDistributionMaxOrderByAggregateInput
    _min?: RewardDistributionMinOrderByAggregateInput
  }

  export type RewardDistributionScalarWhereWithAggregatesInput = {
    AND?: RewardDistributionScalarWhereWithAggregatesInput | RewardDistributionScalarWhereWithAggregatesInput[]
    OR?: RewardDistributionScalarWhereWithAggregatesInput[]
    NOT?: RewardDistributionScalarWhereWithAggregatesInput | RewardDistributionScalarWhereWithAggregatesInput[]
    id?: StringWithAggregatesFilter<"RewardDistribution"> | string
    startTime?: DateTimeWithAggregatesFilter<"RewardDistribution"> | Date | string
    endTime?: DateTimeWithAggregatesFilter<"RewardDistribution"> | Date | string
    totalRewards?: StringWithAggregatesFilter<"RewardDistribution"> | string
    merkleRoot?: StringWithAggregatesFilter<"RewardDistribution"> | string
    merkleProofs?: JsonWithAggregatesFilter<"RewardDistribution">
    createdAt?: DateTimeWithAggregatesFilter<"RewardDistribution"> | Date | string
    updatedAt?: DateTimeWithAggregatesFilter<"RewardDistribution"> | Date | string
  }

  export type ButtonPressCreateInput = {
    id?: string
    address: string
    timestamp?: Date | string
    blockNumber: number
    txHash: string
    createdAt?: Date | string
    updatedAt?: Date | string
  }

  export type ButtonPressUncheckedCreateInput = {
    id?: string
    address: string
    timestamp?: Date | string
    blockNumber: number
    txHash: string
    createdAt?: Date | string
    updatedAt?: Date | string
  }

  export type ButtonPressUpdateInput = {
    id?: StringFieldUpdateOperationsInput | string
    address?: StringFieldUpdateOperationsInput | string
    timestamp?: DateTimeFieldUpdateOperationsInput | Date | string
    blockNumber?: IntFieldUpdateOperationsInput | number
    txHash?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type ButtonPressUncheckedUpdateInput = {
    id?: StringFieldUpdateOperationsInput | string
    address?: StringFieldUpdateOperationsInput | string
    timestamp?: DateTimeFieldUpdateOperationsInput | Date | string
    blockNumber?: IntFieldUpdateOperationsInput | number
    txHash?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type ButtonPressCreateManyInput = {
    id?: string
    address: string
    timestamp?: Date | string
    blockNumber: number
    txHash: string
    createdAt?: Date | string
    updatedAt?: Date | string
  }

  export type ButtonPressUpdateManyMutationInput = {
    id?: StringFieldUpdateOperationsInput | string
    address?: StringFieldUpdateOperationsInput | string
    timestamp?: DateTimeFieldUpdateOperationsInput | Date | string
    blockNumber?: IntFieldUpdateOperationsInput | number
    txHash?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type ButtonPressUncheckedUpdateManyInput = {
    id?: StringFieldUpdateOperationsInput | string
    address?: StringFieldUpdateOperationsInput | string
    timestamp?: DateTimeFieldUpdateOperationsInput | Date | string
    blockNumber?: IntFieldUpdateOperationsInput | number
    txHash?: StringFieldUpdateOperationsInput | string
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type RewardDistributionCreateInput = {
    id?: string
    startTime: Date | string
    endTime: Date | string
    totalRewards: string
    merkleRoot: string
    merkleProofs: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
    updatedAt?: Date | string
  }

  export type RewardDistributionUncheckedCreateInput = {
    id?: string
    startTime: Date | string
    endTime: Date | string
    totalRewards: string
    merkleRoot: string
    merkleProofs: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
    updatedAt?: Date | string
  }

  export type RewardDistributionUpdateInput = {
    id?: StringFieldUpdateOperationsInput | string
    startTime?: DateTimeFieldUpdateOperationsInput | Date | string
    endTime?: DateTimeFieldUpdateOperationsInput | Date | string
    totalRewards?: StringFieldUpdateOperationsInput | string
    merkleRoot?: StringFieldUpdateOperationsInput | string
    merkleProofs?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type RewardDistributionUncheckedUpdateInput = {
    id?: StringFieldUpdateOperationsInput | string
    startTime?: DateTimeFieldUpdateOperationsInput | Date | string
    endTime?: DateTimeFieldUpdateOperationsInput | Date | string
    totalRewards?: StringFieldUpdateOperationsInput | string
    merkleRoot?: StringFieldUpdateOperationsInput | string
    merkleProofs?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type RewardDistributionCreateManyInput = {
    id?: string
    startTime: Date | string
    endTime: Date | string
    totalRewards: string
    merkleRoot: string
    merkleProofs: JsonNullValueInput | InputJsonValue
    createdAt?: Date | string
    updatedAt?: Date | string
  }

  export type RewardDistributionUpdateManyMutationInput = {
    id?: StringFieldUpdateOperationsInput | string
    startTime?: DateTimeFieldUpdateOperationsInput | Date | string
    endTime?: DateTimeFieldUpdateOperationsInput | Date | string
    totalRewards?: StringFieldUpdateOperationsInput | string
    merkleRoot?: StringFieldUpdateOperationsInput | string
    merkleProofs?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type RewardDistributionUncheckedUpdateManyInput = {
    id?: StringFieldUpdateOperationsInput | string
    startTime?: DateTimeFieldUpdateOperationsInput | Date | string
    endTime?: DateTimeFieldUpdateOperationsInput | Date | string
    totalRewards?: StringFieldUpdateOperationsInput | string
    merkleRoot?: StringFieldUpdateOperationsInput | string
    merkleProofs?: JsonNullValueInput | InputJsonValue
    createdAt?: DateTimeFieldUpdateOperationsInput | Date | string
    updatedAt?: DateTimeFieldUpdateOperationsInput | Date | string
  }

  export type StringFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[] | ListStringFieldRefInput<$PrismaModel>
    notIn?: string[] | ListStringFieldRefInput<$PrismaModel>
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    mode?: QueryMode
    not?: NestedStringFilter<$PrismaModel> | string
  }

  export type DateTimeFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    notIn?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeFilter<$PrismaModel> | Date | string
  }

  export type IntFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[] | ListIntFieldRefInput<$PrismaModel>
    notIn?: number[] | ListIntFieldRefInput<$PrismaModel>
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntFilter<$PrismaModel> | number
  }

  export type ButtonPressCountOrderByAggregateInput = {
    id?: SortOrder
    address?: SortOrder
    timestamp?: SortOrder
    blockNumber?: SortOrder
    txHash?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type ButtonPressAvgOrderByAggregateInput = {
    blockNumber?: SortOrder
  }

  export type ButtonPressMaxOrderByAggregateInput = {
    id?: SortOrder
    address?: SortOrder
    timestamp?: SortOrder
    blockNumber?: SortOrder
    txHash?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type ButtonPressMinOrderByAggregateInput = {
    id?: SortOrder
    address?: SortOrder
    timestamp?: SortOrder
    blockNumber?: SortOrder
    txHash?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type ButtonPressSumOrderByAggregateInput = {
    blockNumber?: SortOrder
  }

  export type StringWithAggregatesFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[] | ListStringFieldRefInput<$PrismaModel>
    notIn?: string[] | ListStringFieldRefInput<$PrismaModel>
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    mode?: QueryMode
    not?: NestedStringWithAggregatesFilter<$PrismaModel> | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedStringFilter<$PrismaModel>
    _max?: NestedStringFilter<$PrismaModel>
  }

  export type DateTimeWithAggregatesFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    notIn?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeWithAggregatesFilter<$PrismaModel> | Date | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedDateTimeFilter<$PrismaModel>
    _max?: NestedDateTimeFilter<$PrismaModel>
  }

  export type IntWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[] | ListIntFieldRefInput<$PrismaModel>
    notIn?: number[] | ListIntFieldRefInput<$PrismaModel>
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntWithAggregatesFilter<$PrismaModel> | number
    _count?: NestedIntFilter<$PrismaModel>
    _avg?: NestedFloatFilter<$PrismaModel>
    _sum?: NestedIntFilter<$PrismaModel>
    _min?: NestedIntFilter<$PrismaModel>
    _max?: NestedIntFilter<$PrismaModel>
  }
  export type JsonFilter<$PrismaModel = never> = 
    | PatchUndefined<
        Either<Required<JsonFilterBase<$PrismaModel>>, Exclude<keyof Required<JsonFilterBase<$PrismaModel>>, 'path'>>,
        Required<JsonFilterBase<$PrismaModel>>
      >
    | OptionalFlat<Omit<Required<JsonFilterBase<$PrismaModel>>, 'path'>>

  export type JsonFilterBase<$PrismaModel = never> = {
    equals?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    path?: string[]
    string_contains?: string | StringFieldRefInput<$PrismaModel>
    string_starts_with?: string | StringFieldRefInput<$PrismaModel>
    string_ends_with?: string | StringFieldRefInput<$PrismaModel>
    array_contains?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_starts_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_ends_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    lt?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    lte?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    gt?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    gte?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    not?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
  }

  export type RewardDistributionCountOrderByAggregateInput = {
    id?: SortOrder
    startTime?: SortOrder
    endTime?: SortOrder
    totalRewards?: SortOrder
    merkleRoot?: SortOrder
    merkleProofs?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type RewardDistributionMaxOrderByAggregateInput = {
    id?: SortOrder
    startTime?: SortOrder
    endTime?: SortOrder
    totalRewards?: SortOrder
    merkleRoot?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }

  export type RewardDistributionMinOrderByAggregateInput = {
    id?: SortOrder
    startTime?: SortOrder
    endTime?: SortOrder
    totalRewards?: SortOrder
    merkleRoot?: SortOrder
    createdAt?: SortOrder
    updatedAt?: SortOrder
  }
  export type JsonWithAggregatesFilter<$PrismaModel = never> = 
    | PatchUndefined<
        Either<Required<JsonWithAggregatesFilterBase<$PrismaModel>>, Exclude<keyof Required<JsonWithAggregatesFilterBase<$PrismaModel>>, 'path'>>,
        Required<JsonWithAggregatesFilterBase<$PrismaModel>>
      >
    | OptionalFlat<Omit<Required<JsonWithAggregatesFilterBase<$PrismaModel>>, 'path'>>

  export type JsonWithAggregatesFilterBase<$PrismaModel = never> = {
    equals?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    path?: string[]
    string_contains?: string | StringFieldRefInput<$PrismaModel>
    string_starts_with?: string | StringFieldRefInput<$PrismaModel>
    string_ends_with?: string | StringFieldRefInput<$PrismaModel>
    array_contains?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_starts_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_ends_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    lt?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    lte?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    gt?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    gte?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    not?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedJsonFilter<$PrismaModel>
    _max?: NestedJsonFilter<$PrismaModel>
  }

  export type StringFieldUpdateOperationsInput = {
    set?: string
  }

  export type DateTimeFieldUpdateOperationsInput = {
    set?: Date | string
  }

  export type IntFieldUpdateOperationsInput = {
    set?: number
    increment?: number
    decrement?: number
    multiply?: number
    divide?: number
  }

  export type NestedStringFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[] | ListStringFieldRefInput<$PrismaModel>
    notIn?: string[] | ListStringFieldRefInput<$PrismaModel>
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    not?: NestedStringFilter<$PrismaModel> | string
  }

  export type NestedDateTimeFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    notIn?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeFilter<$PrismaModel> | Date | string
  }

  export type NestedIntFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[] | ListIntFieldRefInput<$PrismaModel>
    notIn?: number[] | ListIntFieldRefInput<$PrismaModel>
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntFilter<$PrismaModel> | number
  }

  export type NestedStringWithAggregatesFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel>
    in?: string[] | ListStringFieldRefInput<$PrismaModel>
    notIn?: string[] | ListStringFieldRefInput<$PrismaModel>
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    not?: NestedStringWithAggregatesFilter<$PrismaModel> | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedStringFilter<$PrismaModel>
    _max?: NestedStringFilter<$PrismaModel>
  }

  export type NestedDateTimeWithAggregatesFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    in?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    notIn?: Date[] | string[] | ListDateTimeFieldRefInput<$PrismaModel>
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeWithAggregatesFilter<$PrismaModel> | Date | string
    _count?: NestedIntFilter<$PrismaModel>
    _min?: NestedDateTimeFilter<$PrismaModel>
    _max?: NestedDateTimeFilter<$PrismaModel>
  }

  export type NestedIntWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[] | ListIntFieldRefInput<$PrismaModel>
    notIn?: number[] | ListIntFieldRefInput<$PrismaModel>
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntWithAggregatesFilter<$PrismaModel> | number
    _count?: NestedIntFilter<$PrismaModel>
    _avg?: NestedFloatFilter<$PrismaModel>
    _sum?: NestedIntFilter<$PrismaModel>
    _min?: NestedIntFilter<$PrismaModel>
    _max?: NestedIntFilter<$PrismaModel>
  }

  export type NestedFloatFilter<$PrismaModel = never> = {
    equals?: number | FloatFieldRefInput<$PrismaModel>
    in?: number[] | ListFloatFieldRefInput<$PrismaModel>
    notIn?: number[] | ListFloatFieldRefInput<$PrismaModel>
    lt?: number | FloatFieldRefInput<$PrismaModel>
    lte?: number | FloatFieldRefInput<$PrismaModel>
    gt?: number | FloatFieldRefInput<$PrismaModel>
    gte?: number | FloatFieldRefInput<$PrismaModel>
    not?: NestedFloatFilter<$PrismaModel> | number
  }
  export type NestedJsonFilter<$PrismaModel = never> = 
    | PatchUndefined<
        Either<Required<NestedJsonFilterBase<$PrismaModel>>, Exclude<keyof Required<NestedJsonFilterBase<$PrismaModel>>, 'path'>>,
        Required<NestedJsonFilterBase<$PrismaModel>>
      >
    | OptionalFlat<Omit<Required<NestedJsonFilterBase<$PrismaModel>>, 'path'>>

  export type NestedJsonFilterBase<$PrismaModel = never> = {
    equals?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
    path?: string[]
    string_contains?: string | StringFieldRefInput<$PrismaModel>
    string_starts_with?: string | StringFieldRefInput<$PrismaModel>
    string_ends_with?: string | StringFieldRefInput<$PrismaModel>
    array_contains?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_starts_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    array_ends_with?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | null
    lt?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    lte?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    gt?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    gte?: InputJsonValue | JsonFieldRefInput<$PrismaModel>
    not?: InputJsonValue | JsonFieldRefInput<$PrismaModel> | JsonNullValueFilter
  }



  /**
   * Aliases for legacy arg types
   */
    /**
     * @deprecated Use ButtonPressDefaultArgs instead
     */
    export type ButtonPressArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = ButtonPressDefaultArgs<ExtArgs>
    /**
     * @deprecated Use RewardDistributionDefaultArgs instead
     */
    export type RewardDistributionArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = RewardDistributionDefaultArgs<ExtArgs>

  /**
   * Batch Payload for updateMany & deleteMany & createMany
   */

  export type BatchPayload = {
    count: number
  }

  /**
   * DMMF
   */
  export const dmmf: runtime.BaseDMMF
}