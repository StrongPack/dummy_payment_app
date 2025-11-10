import { APL, FileAPL, RedisAPL, UpstashAPL } from "@saleor/app-sdk/APL";
import { SaleorApp } from "@saleor/app-sdk/saleor-app";
import { createLogger, loggerContext } from "./lib/logger";

const logger = createLogger("saleor-app");

export const getAPL = (): APL => {
  const apl = process.env.APL;

  logger.info(`Using APL: ${apl}`);

  switch (apl) {
    case "redis": {
      // New case for self-hosted Redis
      const redisUrl = process.env.REDIS_URL;
      if (!redisUrl) {
        logger.error("REDIS_URL not set for redis APL");
        throw new Error("REDIS_URL not set for redis APL. Please set REDIS_URL environment variable.");
      }
      logger.info(`Using Redis APL with url: ${redisUrl}`);
      return new RedisAPL(redisUrl);
    }
    case "upstash":
      logger.info("Using Upstash APL");

      const restURL = process.env.UPSTASH_URL;
      const restToken = process.env.UPSTASH_TOKEN;

      if (!restURL || !restToken) {
        throw new Error("Missing UPSTASH_URL or UPSTASH_TOKEN env variables. Please set them.");
      }

      return new UpstashAPL({
        restURL,
        restToken,
      });
    default:
      logger.info("Using File APL");
      return new FileAPL();
  }
};

export const saleorApp = new SaleorApp({
  apl: getAPL(),
});
