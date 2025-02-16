<?php

declare(strict_types=1);

namespace App\V1\Health\Tests;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use ApiPlatform\Symfony\Bundle\Test\Client;

final class HealthApiTest extends ApiTestCase
{
    private Client $client;

    protected function setUp(): void
    {
        $this->client = self::createClient();
    }

    public function testHealth(): void
    {
        $response = $this->client->request('GET', '/api/v1/health', [
            'headers' => [
                'Accept' => 'application/json',
                'Accept-Language' => 'uk',
            ],
        ]);

        self::assertResponseStatusCodeSame(200);
        self::assertJsonContains(['status' => 'ok']);
    }
}
